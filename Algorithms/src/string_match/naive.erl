%% @author Hasitha
%% @doc @todo Add description to naive.

-module(naive).
-export([naive_string_matcher/2]).

naive_string_matcher(T,P)->
		N = length(T),
		M = length(P),
		if 
				M=<M ->
						Iterations = N - M +1,
						check_similarity(Iterations,T,P,M,N);
				true ->
						{error,invalid}
		end.

check_similarity(0,T,P,M,N)->
		{ok,complete};
check_similarity(Iterations,T,P,M,N)->
		Sublist = lists:sublist(T,Iterations,M),
		if
				P == Sublist ->
						io:format("~p == ~p ~n", [Iterations,Sublist]),
						check_similarity(Iterations-1,T,P,M,N);
				true ->
						check_similarity(Iterations-1,T,P,M,N)
		end.
		