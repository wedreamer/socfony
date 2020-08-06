#!/bin/bash

## Create default l10n.messages arb file.
flutter pub run intl_translation:extract_to_arb \
    --output-dir=l10n-arb \
    --locale=zh_CN \
    --output-file=intl_zh_CN.arb \
    --suppress-meta-data \
    lib/l10n/message/*.dart;

## Using all arb files generate language dart.
flutter pub run intl_translation:generate_from_arb \
    --output-dir=lib/l10n/generated --no-use-deferred-loading \
    lib/l10n/message/*.dart \
    l10n-arb/intl_*.arb;
