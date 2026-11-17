#!/usr/bin/env python3
"""Export a Markdown prose file to styled .docx (Decisions D10-D12).

Called by <leader>e as: export_docs.py [--font F] [--size N] [--spacing S] <path>
Converts via pandoc, applies font/size/spacing via python-docx, prints the
output path. Errors go to stderr with a nonzero exit code.
"""

import argparse
import importlib.util
import shutil
import subprocess
import sys
from pathlib import Path

SPACING_VALUES = {"single": 1.0, "1.5": 1.5, "double": 2.0}


def style_docx(path: Path, font: str, size: int, spacing: str) -> None:
    from docx import Document
    from docx.shared import Pt

    doc = Document(path)
    normal = doc.styles["Normal"]
    normal.font.name = font
    normal.font.size = Pt(size)
    line = SPACING_VALUES[spacing]

    def style_paragraph(para):
        para.paragraph_format.line_spacing = line
        for run in para.runs:
            run.font.name = font
            run.font.size = Pt(size)

    for para in doc.paragraphs:
        style_paragraph(para)
    for table in doc.tables:
        for row in table.rows:
            for cell in row.cells:
                for para in cell.paragraphs:
                    style_paragraph(para)
    doc.save(path)


def main() -> int:
    parser = argparse.ArgumentParser(description="Export Markdown to styled .docx.")
    parser.add_argument("--font", default="Times New Roman", help="Body font (default: %(default)s)")
    parser.add_argument("--size", type=int, default=12, help="Body font size in pt (default: %(default)s)")
    parser.add_argument(
        "--spacing",
        choices=sorted(SPACING_VALUES),
        default="single",
        help="Line spacing (default: %(default)s)",
    )
    parser.add_argument("path", help="Path to the current file")
    args = parser.parse_args()

    src = Path(args.path)
    if not src.is_file():
        print(f"export_docs: no such file: {src}", file=sys.stderr)
        return 1
    if shutil.which("pandoc") is None:
        print(
            "export_docs: pandoc not found; install it first (e.g. sudo apt install pandoc)",
            file=sys.stderr,
        )
        return 2
    if importlib.util.find_spec("docx") is None:
        print(
            f"export_docs: python-docx not found for {sys.executable}; "
            "install it into that interpreter (e.g. sudo apt install python3-docx "
            "or pip install python-docx)",
            file=sys.stderr,
        )
        return 2

    dst = src.with_suffix(".docx")
    proc = subprocess.run(
        ["pandoc", "--from", "markdown", "--to", "docx", "--output", str(dst), str(src)],
        capture_output=True,
        text=True,
    )
    if proc.returncode != 0:
        print(f"export_docs: pandoc failed: {proc.stderr.strip()}", file=sys.stderr)
        return 3
    style_docx(dst, args.font, args.size, args.spacing)
    print(str(dst))
    return 0


if __name__ == "__main__":
    sys.exit(main())
