# Post-commit hook to send patches to an email address

This is useful for complying with coding policies.

## Installation

To configure the hook, change direcory to your Git repository and run:

```sh
# Create the hook file
echo "git send-email HEAD~" > .git/hooks/post-commit
chmod +x .git/hooks/post-commit

# Configure destination address
git config set sendemail.to codingpolicy@suse.com
```

## Usage

Once installed:
 - Whenever you commit a patch, you'll see an outline of the email before it's sent, and you'll have the option to cancel sending.
 - you will get a CC'd copy of each such email

To send a specific commit range (e.g., to resend or send a missed commit), use:

```sh
git send-email <commit-range>
```

## Optional Configuration

- To send all commits automatically without confirmation prompts: `git config set sendemail.confirm never`

- to customize the sender (From) address: `git config set sendemail.from your-user@suse.com`

- to customize the CC address: `git config set sendemail.cc your-user@suse.com`

- to use GMail as the sending server follow instructions at: https://github.com/google/gmail-oauth2-tools/tree/master/go/sendgmail
   - Note: For step 3, skip the instruction to 'Add USERNAME@gmail.com as a test user.' This step is no longer necessary. Also go to **APIs & Services > OAuth consent screen > Data Access** in order to add the scope

## Troubleshooting

Use:
```sh
git send-email --smtp-debug --to your-user@suse.com HEAD~
```

To send an email to yourself as a test.
