from InquirerPy import get_style, inquirer
from InquirerPy.base.control import Choice
import json
from InquirerPy.validator import PathValidator
from rich.prompt import Prompt

def cache_save(key, value):
    """Save a value to the cache file."""
    try:
        with open("/tmp/cbx-cache.json", "r") as jsonfile:
            cache = json.load(jsonfile)
    except FileNotFoundError:
        cache = {}

    cache[key] = value

    with open("/tmp/cbx-cache.json", "w") as jsonfile:
        json.dump(cache, jsonfile)

def cache_get(key):
    """Get cache value."""
    try:
        with open("/tmp/cbx-cache.json", "r") as jsonfile:
            cache = json.load(jsonfile)
        return cache.get(key)
    except FileNotFoundError:
        return None

colors = {
    "answer": "#ff00fb",
    "answered_question": "",
    "answermark": "#ff0055",
    "checkbox": "#00ff7b",
    "fuzzy_border": "",
    "fuzzy_info": "#abb2bf",
    "fuzzy_match": "#ff00fb",
    "fuzzy_prompt": "#ff00fb",
    "input": "#00ff7b",
    "instruction": "#abb2bf",
    "long_instruction": "#abb2bf",
    "marker": "#ff0055",
    "pointer": "#ff00fb",
    "question": "",
    "questionmark": "#ff0055 bold",
    "separator": "",
    "skipped": "#5c6370",
    "spinner_pattern": "#ff0055",
    "spinner_text": "",
    "validator": "",
}


def select_prompt(
    choices: list[Choice], message: str, instruction: str = "", **kwargs
) -> str:
    style = get_style(
        colors,
        style_override=True,
    )
    return inquirer.select(
        choices=choices,
        message=message,
        style=style,
        instruction=instruction,
        **kwargs,
    ).execute()

def default_prompt(message: str, **kwargs) -> str:
    style = get_style(
        colors,
        style_override=True,
    )
    default_key = kwargs.get("default_key")
    default = kwargs.get("default")
    if default_key:
        cache_default_value = cache_get(default_key)
        if cache_default_value:
            default = cache_default_value
    return inquirer.text(
        message=f"{message}",
        style=style,
        default=f"{default}",
    ).execute()