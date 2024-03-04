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
    "fuzzy_border": "",
    "fuzzy_match": "#ff00fb",
    "spinner_pattern": "#ff0055",
    "spinner_text": "",
}


style = get_style(colors, style_override=True)

app = typer.Typer(rich_markup_mode="rich")

init_app = typer.Typer(rich_markup_mode="rich")


@app.callback()
def callback():
    print("\nLet's get started ! :rocket:")


app.add_typer(init_app, name="init", callback=callback)


@app.command()
def start():
    choices = [
        Choice(value="1", name="Docker \U0001F433"),
        Choice(value="2", name="Poetry \U0001F4D6"),
        Choice(value="3", name="Git \U0001F33F"),
    ]

    user_choice = inquirer.select(
        choices=choices,
        default="1",
        message="Wich type of command do you want to run ?",
        style=style,
    ).execute()

    print(f"You chose: {user_choice}")
