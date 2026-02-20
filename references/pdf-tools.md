# PDF Tool Detection and Fallback Strategy

After Step 1 scans the `book/` folder, detect available tools in priority order:

## Detection Priority

| Priority | Tool | Supported Formats | Detection Method |
|----------|------|-------------------|-----------------|
| 1 | `pdf-official` skill | .pdf (full operations) | Attempt call; use if successful |
| 2 | `firecrawl-scraper` skill | .pdf (URL-based) | Suitable for online PDFs |
| 3 | `docx` skill | .docx | Attempt call |
| 4 | `view_file` direct read | .txt / .md | Always available |
| 5 | No tool fallback | — | Ask user to provide text summary |

## Fallback Logic

```
if pdf-official is available:
    Read all PDF files directly
elif firecrawl is available AND file is a URL:
    Use firecrawl to fetch
elif file is .txt or .md:
    Use view_file to read directly
else:
    Prompt user:
    "Cannot automatically read this PDF. Please paste the core content
     as text, or convert the PDF to .txt and place it in the book/ folder."
```

## Partial Readability

When `book/` contains mixed formats (some readable, some not):

1. Process all readable files first and complete knowledge extraction
2. After Step 2, report which files could not be read
3. Ask the user whether to provide text summaries for those books
4. Merge user-provided content into extraction results and continue to Step 3
