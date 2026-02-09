; extends
;; checked checklist markers "- [x] text"
(
  list_item
    (list_marker_minus) @d4rk.markdown.task_checked_marker_minus
    (task_list_marker_checked) @d4rk.markdown.task_checked_marker
    (paragraph
      (inline) @d4rk.markdown.task_checked_text
    )
)

;; horizontal rule "---"
(thematic_break) @d4rk.markdown.horizontal_rule

;; block quote markers ">"
[
  (block_quote_marker)
  (block_continuation)
] @d4Rk.markdown.block_quote_marker
