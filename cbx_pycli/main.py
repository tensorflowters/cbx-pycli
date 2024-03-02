import typer
from InquirerPy import get_style, inquirer
from InquirerPy.base.control import Choice
from rich import print

colors = {
    "questionmark": "#ff0055 bold",
    "answermark": "#ff0055",
    "answer": "#ff00fb",
    "input": "#00ff7b",
    "question": "",
    "answered_question": "",
    "instruction": "#abb2bf",
    "long_instruction": "#abb2bf",
    "pointer": "#ff00fb",
    "checkbox": "#00ff7b",
    "separator": "",
    "skipped": "#5c6370",
    "validator": "",
    "marker": "#ff0055",
    "fuzzy_prompt": "#ff00fb",
    "fuzzy_info": "#abb2bf",
    "fuzzy_border": "#4b5263",
    "fuzzy_match": "#ff00fb",
    "spinner_pattern": "#ff0055",
    "spinner_text": "",
}


style = get_style(colors, style_override=True)

app = typer.Typer(rich_markup_mode="rich")

@app.callback()
def callback():
    """
    Let's get started !

    The aim of this project is to create a CLI that will help you automate recurring tasks.
    """

@app.command()
def start():
    choices = [
        Choice(value="opt1", name="Option 1"),
        Choice(value="opt2", name="Option 2"),
        Choice(value="opt3", name="Option 3"),
    ]

    user_choice = inquirer.select(
        choices=choices,
        default="opt1",
        message="Please choose an option:",
        style=style,
        vi_mode=True,
    ).execute()

    print(f"You chose: {user_choice}")
