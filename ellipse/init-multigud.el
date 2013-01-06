(setq gdb-many-windows t)
(load-library "multi-gud.el")
(load-library "multi-gdb-ui.el")
(setq gdb-use-separate-io 1)

(defadvice gdb-frame-handler-1 (after activate)
  (if gdb-use-separate-io-buffer
      (advice_separate_io)
    (advice_no_separate_io)))

(defun advice_separate_io()
  ;;默认的生成gdb-assembler-buffer的函数本身也会设计调用gdb-frame-handler-1，加入此条件发生避免无限递归调用
  (if (not (gdb-get-buffer 'gdb-assembler-buffer))
      (progn
		(split-window-horizontally)
		(enlarge-window-horizontally ( / (window-width) 3))
		(other-window 1)

		;;此处不能使用(gdb-set-window-buffer (gdb-get-buffer-create 'gdb-inferior-io))代替，
		;;因为在打开gdb-use-separate-io-buffer的状态时，它还会额外调用一些函数将gdb的input，output定位到该buffer
		(gdb-set-window-buffer (gdb-inferior-io-name))

		(other-window 1)
		(split-window-horizontally)

		(other-window 1)
		(gdb-set-window-buffer (gdb-stack-buffer-name))

		(other-window 1)

		(other-window 1)
		(toggle-current-window-dedication)
		(gdb-set-window-buffer (gdb-get-buffer-create 'gdb-assembler-buffer))
		(toggle-current-window-dedication)

		(split-window-horizontally  (/ ( * (window-width) 2) 3))

		(other-window 1)
		(gdb-set-window-buffer (gdb-get-buffer-create 'gdb-registers-buffer))

		(other-window 1)
		(toggle-current-window-dedication)
		(gdb-set-window-buffer (gdb-get-buffer-create 'gdb-memory-buffer))
		(toggle-current-window-dedication)

		(other-window 2)
		)))

(provide 'init-multigud)
