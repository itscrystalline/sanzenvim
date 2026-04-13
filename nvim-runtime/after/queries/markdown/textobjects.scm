;; extends
;; Define code cell textobjects for navigation in markdown notebooks
;; This allows using ]b and [b to jump between code cells
(fenced_code_block (code_fence_content) @code_cell.inner) @code_cell.outer
