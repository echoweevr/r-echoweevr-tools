# r-echoweevr-tools

R package with tools for analysis of echoweevr data

# How to install

Install through pak:

```r
pak::pak("echoweevr/r-echoweevr-tools")
```
# Overview

Right now, there is only one function: echoweevr.tools::load_json_export. Its parameter can be a JSON string, a URL, or a file path to an echoweevr export file. It takes the JSON export from echoweevr that looks like this:

```json
[
    {
        "responseId": "002133ec-d559-455f-9da3-9922c480d561",
        "respondentId": "119236218629",
        "questionKey": "what_is_one_task_youd_never_trust_ai_to_do_why",
        "response": "All",
        "codes": [
            {
                "key": "distrust_everything",
                "source": "ai"
            }
        ]
    },
    {
        "responseId": "00adf06f-41c1-4530-9f5d-18d0c077a326",
        "respondentId": "119236189127",
        "questionKey": "what_ai_mistake_has_affected_you",
        "response": "not really because I examine every details before using it",
        "codes": [
            {
                "key": "no_mistake_experienced",
                "source": "ai"
            },
            {
                "key": "verification_caught_error",
                "source": "ai"
            }
        ]
    }
]
```

The function returns a Tidyverse tibble that looks like the following:

```text
> load_json_export("small_export.json")
# A tibble: 3 × 6
  response_id       respondent_id question_key response code  source
  <chr>             <chr>         <chr>        <chr>    <chr> <chr> 
1 002133ec-d559-45… 119236218629  what_is_one… All      dist… ai    
2 00adf06f-41c1-45… 119236189127  what_ai_mis… not rea… no_m… ai    
3 00adf06f-41c1-45… 119236189127  what_ai_mis… not rea… veri… ai
```
