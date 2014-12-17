#!/bin/bash
ruby battleships.rb <<EOF
	$(for i in {0..9}; do for j in {0..9}; do echo "$i,$j"; done; done)
EOF
