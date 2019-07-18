#/--------------------------------------------------------------------
#| Copyright 2017 Erisata, UAB (Ltd.)
#|
#| Licensed under the Apache License, Version 2.0 (the "License");
#| you may not use this file except in compliance with the License.
#| You may obtain a copy of the License at
#|
#|     http://www.apache.org/licenses/LICENSE-2.0
#|
#| Unless required by applicable law or agreed to in writing, software
#| distributed under the License is distributed on an "AS IS" BASIS,
#| WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#| See the License for the specific language governing permissions and
#| limitations under the License.
#\--------------------------------------------------------------------

REBAR=rebar3

all: compile

deps:
	$(REBAR) get-deps

compile:
	$(REBAR) compile

xref:
	$(REBAR) xref

check: test itest xref

test:
	$(REBAR) eunit --verbose

itest:
	$(REBAR) ct $(CT_ARGS)

docs:
	$(REBAR) as docs edoc

clean:
	$(REBAR) clean

clean-all:
	$(REBAR) clean --all

#
#  Rebar hooks
#
rebar_ct_post:
	@make -C _build/test/logs -f ../../../Makefile rebar_ct_post_logs

rebar_ct_post_logs:
	@rm -rf logs && ln -vs $(shell find . -name "ct_run.*" | sort | tail -n 1)/logs/ logs

rebar_edoc_post:
	@sed -i 's|/blob/[^/]*/|/blob/master/|g' README.md
	@sed -i "s|`pwd`/||g" doc/*.md


.PHONY: all deps compile check test itest xref docs clean clean-all


