from slack_sdk import WebClient
from slack_sdk.errors import SlackApiError

slack_token = "xoxb-....."
client = WebClient(token=slack_token)

try:
    # Use files_upload-V2 (latest method)
    response = client.files_upload_V2(
        channel = "C08...",
        initial_comment="AWS Cost Report",
        file="cost-report.txt"
    )
    print("File uploaded successfully:", response)

except SlackApiError as e:
    print(f"Error uploadiing file: {e.response['error']}")


### aws-cost --text > cost-report.txt

# python3 upload_cost_report.py