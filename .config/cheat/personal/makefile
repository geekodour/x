# printing in a makefile
$(info ${VAR_NAME})

# existence of env var
#
# inline variant
@test -n "$(VAR_NAME)" || (echo 'error msg' && exit 1)
# global variant, no indentation at all
ifndef ENV_VAR_X
	$(error ENV_VAR_X is undefined)
endif

