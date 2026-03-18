from __future__ import annotations

import json
from pathlib import Path
from typing import Any, Dict


DEFAULT_INPUT_PATH = "/tmp/chatgpt_terminal_last.json"


class TerminalFormatter:
    """
    Format the last terminal command record into a clean prompt
    for ChatGPT app/web.
    """

    def __init__(
        self,
        input_path: str = DEFAULT_INPUT_PATH,
        max_output_chars: int = 8000,
    ):
        self.input_path = Path(input_path)
        self.max_output_chars = max_output_chars

    def load_last_record(self) -> Dict[str, Any]:
        if not self.input_path.exists():
            raise FileNotFoundError(
                f"Terminal log file not found: {self.input_path}"
            )

        with self.input_path.open("r", encoding="utf-8") as f:
            data = json.load(f)

        if not isinstance(data, dict):
            raise ValueError("Expected a JSON object in terminal log file")

        return data

    def format_last_record(self) -> str:
        record = self.load_last_record()
        return self.format_record(record)

    def format_record(self, record: Dict[str, Any]) -> str:
        timestamp = str(record.get("timestamp", "unknown"))
        cwd = str(record.get("cwd", "unknown"))
        command = str(record.get("command", "unknown"))
        exit_code = record.get("exit_code", "unknown")
        output = str(record.get("output", ""))

        trimmed_output = self._trim_output(output)

        parts = [
            "I ran this terminal command:",
            "",
            command,
            "",
            "Current directory:",
            "",
            cwd,
            "",
            f"Exit code: {exit_code}",
            "",
            f"Timestamp: {timestamp}",
            "",
            "Output:",
            "",
            trimmed_output if trimmed_output else "(no output)",
            "",
            "Please tell me the next command to run and briefly explain why.",
        ]

        return "\n".join(parts).strip()

    def _trim_output(self, output: str) -> str:
        if len(output) <= self.max_output_chars:
            return output

        head = output[: self.max_output_chars // 3]
        tail = output[-(self.max_output_chars - len(head) - 40):]

        return (
            head
            + "\n\n...[output truncated]...\n\n"
            + tail
        )


def main() -> None:
    formatter = TerminalFormatter()
    print(formatter.format_last_record())


if __name__ == "__main__":
    main()