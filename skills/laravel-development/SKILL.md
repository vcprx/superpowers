---
name: laravel-development
description: >
  Use when writing or reviewing PHP/Laravel code, or when working in a Laravel
  project (files like artisan, app/, routes/, composer.json with laravel/framework).
  TRIGGER when: user writes PHP classes, controllers, models, jobs, commands,
  service providers, or asks about Laravel architecture, modules, or coding conventions.
  DO NOT TRIGGER when: working on non-PHP projects or pure front-end (JS/CSS) tasks.
user-invocable: false
disable-model-invocation: false
---

# Laravel Development

This skill family covers common Laravel development tasks. Each sub-skill handles a specific
concern; invoke the most appropriate one for the task at hand.

## Available Sub-Skills

| Sub-skill | File | When to invoke |
|-----------|------|----------------|
| `developing-modular-laravel` | `developing-modular-laravel.md` | Creating or editing a module — including scaffolding the directory structure, registering a service provider, adding models with factories, or wiring a new namespace |
| `laravel-guidelines` | `laravel-guidelines.md` | Writing or reviewing any Laravel/PHP code — apply naming conventions, control flow rules, type declarations, and Laravel-specific patterns |

## When to Invoke Each Sub-Skill

**`developing-modular-laravel`** — invoke when the user asks to:
- Scaffold a new module directory under `modules/`
- Register a module's service provider (in `ModuleServiceProvider` or `bootstrap/providers.php`)
- Wire a new `Modules\` PSR-4 namespace in `composer.json`
- Set up an Eloquent factory for a module model (using `#[UseFactory]`)
- Establish the modular structure for the first feature of a new Laravel project

**`laravel-guidelines`** — invoke when the user asks to:
- Write new PHP or Laravel code (controllers, models, jobs, commands, etc.)
- Review or refactor existing Laravel code for style compliance
- Apply Spatie-style conventions to naming, control flow, or type declarations
- Resolve questions about Laravel coding standards
