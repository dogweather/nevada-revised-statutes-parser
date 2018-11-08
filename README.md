Parser for the Nevada Revised Statutes 
======================================

[![Build Status](https://travis-ci.org/public-law/nevada-revised-statutes-parser.svg?branch=master)](https://travis-ci.org/public-law/nevada-revised-statutes-parser)

**Input:** The [Nevada Revised Statutes website](https://www.leg.state.nv.us/NRS/), downloaded with `wget` into `/tmp`.

**Output:** Semantic JSON:

```json
{
    "nominalDate": 2018,
    "dateAccessed": "2018-01-28",
    "statuteTree": {
        "titles": [
            {
                "chapters": [
                    {
                        "url": "https://www.leg.state.nv.us/nrs/NRS-1.html",
                        "name": "Judicial Department Generally",
                        "number": "1",
                        "subChapters": [
                            {
```

etc.

Opinionated Resources for Haskell Best Practices
------------------------------------------------

* [An Opinionated Guide to Haskell in 2018](https://lexi-lambda.github.io/blog/2018/02/10/an-opinionated-guide-to-haskell-in-2018/)
* [Haskell Porting Notes](https://github.com/srid/slownews/blob/master/notes/haskell-port.md)
* [Haskell Package Checklist](http://taylor.fausak.me/haskell-package-checklist/)
* [Haskell Data Types in 5 Steps](https://mmhaskell.com/blog/2017/12/24/haskell-data-types-in-5-steps)
