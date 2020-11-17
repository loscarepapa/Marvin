# Marvin

**Bot to bring the entire portfolio of policies issued in Qualitas**

## Use 

Start ChromeDriver with `./chromedriver --port=9515 --verbose background=true`

Init iex with `iex -S mix`

Init Scrawper with `Marvin.run`

Create a file named credentials.json with the next code `
[
    {
        "born": "<Date of creation agent>",
        "agente": "<Key>",
        "username": "<Count>",
        "pass": "<Password>"
    }
]
`

