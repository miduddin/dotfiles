function h -w helm
	helm --kube-context $argv[1] -n $argv[2] $argv[3..]
end
