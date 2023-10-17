function gc
	git remote prune origin
	git reflog expire --expire=now --all
	git repack -ad
	git prune
end
