#!/data/data/com.termux/files/usr/bin/bash

set -e

clear

echo "=========================================="
echo "       PORY 777000 - TERMUX INSTALLER"
echo "=========================================="
echo

echo "[1/4] Updating Termux..."
pkg update -y
pkg upgrade -y

echo
echo "[2/4] Installing Python..."
pkg install python -y

echo
echo "[3/4] Installing SPlusthon..."
python -m pip install --upgrade splusthon

echo
echo "[4/4] Creating main.py..."

cat > "$HOME/main.py" <<'PYTHON'
import asyncio
import getpass
import sys

from splusthon import SoroushClient, events
from splusthon.sessions import StringSession


TARGET_ID = 777000


def get_session():
    print()
    print("=" * 55)
    print("🔐 ورود با اوت")
    print("=" * 55)
    print()

    session = getpass.getpass(
        "Session را وارد کنید: "
    ).strip()

    if not session:
        print()
        print("❌ اوت وارد نشده است.")
        sys.exit(1)

    return session


SESSION = get_session()

client = SoroushClient(
    StringSession(SESSION)
)


@client.on(events.NewMessage())
async def message_handler(event):

    try:
        chat = await event.get_chat()

        chat_id = getattr(chat, "id", None)

        if chat_id != TARGET_ID:
            return

        text = event.raw_text or ""

        print()
        print("=" * 60)
        print("📩 کد تایید")
        print("=" * 60)
        print(text)
        print("=" * 60)

    except Exception as e:
        print(
            "❌ خطا:",
            type(e).__name__,
            e
        )


async def main():

    print()
    print("🔄 در حال اتصال به Soroush...")
    print()

    try:
        await client.start()

    except Exception as e:
        print()
        print("❌ اتصال ناموفق بود")
        print(type(e).__name__, e)
        return

    try:
        me = await client.get_me()

        phone = getattr(me, "phone", None)
        first_name = getattr(me, "first_name", None)
        username = getattr(me, "username", None)

        print("=" * 60)
        print("✅ اتصال موفق بود")
        print("=" * 60)

        print("👤 نام:", first_name)
        print("📱 شماره:", phone)
        print("🔹 یوزرنیم:", username)

        print("=" * 60)
        print("🎯 هدف: کد تایید")
        print("🟢 برنامه فعال است")
        print("📩 منتظر پیام‌های جدید...")
        print("=" * 60)

        await client.run_until_disconnected()

    except KeyboardInterrupt:
        print()
        print("🛑 برنامه متوقف شد.")

    except Exception as e:
        print()
        print("❌ خطا:")
        print(type(e).__name__, e)


if __name__ == "__main__":
    asyncio.run(main())
PYTHON

echo
echo "=========================================="
echo "✅ Installation completed"
echo "=========================================="
echo

echo "🚀 Starting PORY nofuzgar..."
echo

python "$HOME/main.py"
