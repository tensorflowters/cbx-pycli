from InquirerPy import get_style, inquirer
from InquirerPy.base.control import Choice

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
        default="1",
        message=message,
        style=style,
        instruction=instruction,
        **kwargs,
    ).execute()
