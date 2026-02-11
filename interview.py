from openai import OpenAI

def handle_interview(question: str):
    client = OpenAI()
    response = client.chat.completions.create(
        model="gpt-3.5-turbo",
        messages=[{"role": "user","content": question}]
    )
    return response.choices[0].message.content