import os
from openai import OpenAI

# Ask for the OpenAI API key and set up the client
api_key = 'INSERT YOUR API KEY HERE'
client = OpenAI(api_key=api_key)

def transcribe_audio(file_path):
    try:
        with open(file_path, "rb") as audio_file:
            # Assuming the transcription is returned as a string directly
            transcription = client.audio.transcriptions.create(
                model="whisper-1",
                file=audio_file,
                response_format="text"
            )
        # Check if transcription is a string or an object with a 'text' attribute
        if isinstance(transcription, str):
            return transcription
        else:
            return transcription.text
    except Exception as e:
        print(f"An error occurred: {e}")
        return None


def save_transcription(text, path):
    base, ext = os.path.splitext(path)
    output_path = base + ".txt"
    count = 1
    while os.path.exists(output_path):
        output_path = f"{base}_{count}.txt"
        count += 1
    with open(output_path, 'w') as file:
        file.write(text)
    return output_path

def main():
    audio_path = input("Enter the path to the audio file: ")
    audio_path = r"{}".format(audio_path)  # Treat the path as a raw string
    
    if not os.path.exists(audio_path):
        print("The file does not exist. Please check the path and try again.")
        return

    transcription = transcribe_audio(audio_path)
    if transcription is None:
        print("Failed to transcribe the audio.")
        return

    output_file = save_transcription(transcription, audio_path)
    print(f"Transcription saved successfully at {output_file}")

if __name__ == "__main__":
    main()
