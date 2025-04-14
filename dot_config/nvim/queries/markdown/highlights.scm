;; Matches text after checked box (- [x] <text>)
(list_item
  (task_list_marker_checked)
  (paragraph (inline) @markup.list.checked))
