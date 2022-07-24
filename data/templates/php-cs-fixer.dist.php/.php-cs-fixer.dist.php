<?php

declare(strict_types=1);

return (new PhpCsFixer\Config())
    ->setRules([
        '@PhpCsFixer' => true,
        'phpdoc_separation' => false,
        'phpdoc_types_order' => ['null_adjustment' => 'always_last'],
        'phpdoc_no_empty_return' => false,
        'blank_line_before_statement' => false,
        'no_empty_comment' => false,
        'single_line_comment_style' => ['comment_types' => ['hash']],
        'no_superfluous_phpdoc_tags' => false,
        'php_unit_internal_class' => false,
        'php_unit_method_casing' => false,
        'php_unit_test_class_requires_covers' => false,
        'phpdoc_to_comment' => false,
    ])
    ->setFinder(
        PhpCsFixer\Finder::create()
            ->in(__DIR__)
            ->exclude(['bootstrap', 'vendor', 'cdk.out'])
            ->notPath(['_ide_helper.php', '_ide_helper_models.php'])
    )
;
