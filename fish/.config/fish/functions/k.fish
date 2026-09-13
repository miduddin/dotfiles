function k
	if test (count $argv) -eq 1
		k9s --context $argv[1]
	else
		kubectl --context $argv[1] -n $argv[2] $argv[3..]
	end
end
