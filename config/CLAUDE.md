# Global Claude Instructions

- Be concise and direct. No filler phrases.
- Be critical when I am wrong — do not just agree.
- Before starting any task, evaluate available skills and load any that are relevant using the ToolSearch tool.

## PHP / Laravel Projects

Always load the `laravel-development` skill before proceeding if any of the following are present:
- `artisan` file in the project root
- `composer.json` containing `laravel/framework`
- `app/Http/` or `app/Models/` directories

## Using GitHub
- For questions about GitHub, use the gh tool
- Never mention Claude Code in PR descriptions, PR comments, or issue comments
