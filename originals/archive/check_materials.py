"""Verify byte-exact mirrors of previously anonymized original project material."""

from pathlib import Path, PurePosixPath
import argparse
import hashlib
import json
import re
import zipfile

HERE = Path(__file__).resolve().parent
REPO = HERE.parents[1]
EXPECTED = {
    "originals/archive/project_01/register-state.xlsx",
    "originals/archive/project_01/instruction-notes.xlsx",
    "originals/archive/project_01/legacy-ise.xise",
    "originals/archive/project_01/corrupt-Final.xise",
    "originals/archive/project_01/EX.ucf",
    "originals/archive/project_02/report.pdf",
    "originals/archive/project_02/hazard-wiring.PNG",
    "originals/archive/project_03/report.pdf",
    "originals/archive/project_03/References.docx",
    "originals/archive/project_03/reference-processor-report-01.pdf",
    "originals/archive/project_03/reference-processor-report-02.pdf",
    "originals/archive/project_04/report.pdf",
    "originals/archive/project_04/report.docx",
}


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--allow-unpinned", action="store_true", help="Allow the parent integration task to fill the original repository commit later.")
    args = parser.parse_args()
    manifest = json.loads((HERE / "materials.json").read_text(encoding="utf-8"))
    assert manifest["schema_version"] == 1
    origin = manifest["origin"]
    assert origin["repository"] == "handsomegary/computer-organization-verilog-projects"
    assert re.fullmatch(r"[0-9a-f]{64}", origin["materials_manifest_sha256"])
    if not args.allow_unpinned:
        assert re.fullmatch(r"[0-9a-f]{40}", origin.get("source_commit") or ""), "Fill origin.source_commit with the original repository commit before publication."
    records = manifest["files"]
    assert len(records) == 13
    assert {record["path"] for record in records} == EXPECTED
    for record in records:
        relative = PurePosixPath(record["path"])
        assert not relative.is_absolute() and ".." not in relative.parts
        path = (REPO / record["path"]).resolve()
        assert path.is_relative_to(HERE.resolve()), record["path"]
        data = path.read_bytes()
        assert len(data) == record["published_bytes"], record["path"]
        assert hashlib.sha256(data).hexdigest() == record["published_sha256"], record["path"]
        assert not data.startswith(b"version https://git-lfs.github.com/spec/"), record["path"]
        preserved = record["preservation_record"]
        assert preserved["review_mirror"] is True
        assert preserved["path"] == record["path"]
        assert preserved["archived_sha256"] == record["published_sha256"]
        assert preserved["archived_bytes"] == record["published_bytes"]
        serialized = json.dumps(preserved, ensure_ascii=False, sort_keys=True, separators=(",", ":")).encode("utf-8")
        assert hashlib.sha256(serialized).hexdigest() == record["preservation_record_sha256"], record["path"]
        # The origin's complete record is retained verbatim rather than
        # replacing its original-document limitations with runtime test claims.
        if path.suffix.lower() in {".docx", ".xlsx"}:
            assert record.get("zip_container_verified") is True, record["path"]
            with zipfile.ZipFile(path) as package:
                assert package.testzip() is None, record["path"]
        if data and path.suffix.lower() == ".pdf":
            assert data.startswith(b"%PDF-"), record["path"]
    print("Historical material mirrors OK: 13 original anonymous artifacts; exact hashes and full preservation records verified.")
    if origin.get("source_commit") is None:
        print("Original repository commit is pending parent integration (--allow-unpinned).")


if __name__ == "__main__":
    main()
