%% @author Hasitha
%% @doc @todo Add description to rabin_karp.

-module(rabin_karp).
-compile(export_all).
-define(PRIME,3).

get_matching_index([],_MatchingList)->
	{ok,-1};
get_matching_index(_InputList,[])->
	{ok,-1};
get_matching_index(InputList,MatchingList)->
	case get_hash_value(lists:reverse(MatchingList), ?PRIME, 0)of
		{ok,HashValue}->
			Sublist = lists:sublist(InputList,1,length(MatchingList)),
			case get_hash_value(lists:reverse(Sublist), ?PRIME, 0)of
		  	{ok,SublistHashValue}->
						if
							HashValue==SublistHashValue ->
								if
									Sublist==MatchingList->
										{ok,3};
									true->
										check_hash_matching(InputList,MatchingList,HashValue,length(InputList),length(MatchingList),
												2,length(InputList)-length(MatchingList)-1,SublistHashValue,Sublist)
								end;
							true ->
								check_hash_matching(InputList,MatchingList,HashValue,length(InputList),length(MatchingList),
										2,length(InputList)-length(MatchingList)-1,SublistHashValue,Sublist)
						end;
				_ ->
						{ok,-1}
			end;
		_ ->
			{ok,-1}
	end.

check_hash_matching(_InputList,_MatchingList,_MatchingHash,_InputLength,_MatchingLength,_Index,0,_PreviousHashValue,_PreviousSublist)->
		{ok,-1};
check_hash_matching(InputList,MatchingList,MatchingHash,InputLength,MatchingLength,Index,Limit,PreviousHashValue,PreviousSublist)->
	io:format("{InputList,MatchingList,MatchingHash,InputLength,MatchingLength,Index,Limit,PreviousHashValue,PreviousSublist} : ~p~n",
						[{InputList,MatchingList,MatchingHash,InputLength,MatchingLength,Index,Limit,PreviousHashValue,PreviousSublist}]),
	case lists:sublist(InputList,Index,MatchingLength) of
			[]->
					io:format("Sublist empty. ~n",[]),
					{ok,-1};
			Sublist ->
					io:format("Sublist : ~p~n",[Sublist]),
					case get_hash_value(PreviousSublist,Sublist,PreviousHashValue,?PRIME)of
						{ok,HashValue}->
							io:format("SublistHashValue : ~p~n",[HashValue]),
							if
								HashValue==MatchingHash ->
									if
										Sublist==MatchingList->
											{ok,Index};
										true->
											check_hash_matching(InputList,MatchingList,MatchingHash,InputLength,MatchingLength,Index+1,Limit,HashValue,Sublist)
									end;
								true ->
									check_hash_matching(InputList,MatchingList,MatchingHash,InputLength,MatchingLength,Index+1,Limit,HashValue,Sublist)
							end;
						_ ->
							io:format("get_hash_value/4 error ~n",[]),
							{ok,-1}
					end
	end.

%% For direct hash value calculation.
get_hash_value([Char|T],Prime,Sum)->
	io:format("{Char,T,Prime,Sum} : ~p~n",[{Char,T,Prime,Sum}]),
	case get_ascii_value(Char) of
		{ok,Ascii}->
			get_hash_value(T,Prime,Sum+Ascii*math:pow(Prime,length(T)));
		_ ->
			{error,error}
	end;
get_hash_value([],_Prime,Sum)->
	io:format("Sum : ~p~n",[Sum]),
	{ok,Sum}.

%% For rotating hash value calculation, using previous hash value.
get_hash_value([FirstChar|_ ],CurrentCharList,HashValue,Prime)->
	io:format("{FirstChar,CurrentCharList,HashValue,Prime} : ~p~n",[{FirstChar,CurrentCharList,HashValue,Prime}]),
	case get_ascii_value(FirstChar) of
		{ok,AsciiFirst} ->
			io:format("AsciiFirst : ~p~n",[AsciiFirst]),
			case get_ascii_value(lists:last(CurrentCharList)) of
				{ok,AsciiLast} ->
					io:format("AsciiLast : ~p~n",[AsciiLast]),
					NewHashValue = (HashValue-AsciiFirst)/Prime + AsciiLast*math:pow(Prime,length(CurrentCharList)-1),
					io:format("NewHashValue : ~p~n",[NewHashValue]),
					{ok,NewHashValue};
				_ ->
					{error,error}
			end;
		_ ->
			{error,error}
	end.

get_ascii_value(Char)->
	if
		is_atom(Char)->
			[Ascii]=atom_to_list(Char),
			{ok,Ascii};
		is_list(Char)->
			[Ascii]=Char,
			{ok,Ascii};
		is_integer(Char)->
			Ascii=Char,
			{ok,Ascii};
		true ->
			{error,error}
	end.