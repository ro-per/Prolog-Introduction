%%%%%%%%%%%%%%%%%%% /* GRAPH */ %%%%%%%%%%%%%%%%%%%%
edge(zwolle,apeldoorn,39.5).
edge(apeldoorn,zutphen,23.4).
edge(hengelo,zwolle,63.5).
edge(zutphen,hengelo,46.7).
edge(arnhem,apeldoorn,35.4).
edge(arnhem,zutphen,35.6).

/* MAKES GRAPH BI-DIRECTIONAL*/
connected(X,Y,L) :- edge(X,Y,L) ; edge(Y,X,L).						


%%%%%%%%%%%%%%%%%%% /* SIMPLIFIED CALLS */ %%%%%%%%%%%%%%%%%%%%
shortest_simple:-
	read_var2(Start,'Start-location',Stop,'Stop-location',user),	/* Ask user for start- & stop-location */
	shortest_simple(Start,Stop).
	
shortest_simple(Start,Stop):-
	shortest_from_list([Start,Stop],user).
	
shortest_complex:-
	read_var2(InStream,'Inputstream',OutStream,'Outputstream',user),/* Ask user for input- & output-stream */
	shortest_complex(InStream,OutStream).

shortest_complex(InStream,OutStream):-
	stream_to_list(InStream,InList),								/* Read stream into list */				
	open(OutStream, write, TempStream),								/* Open TempStream from Outstream to write to */
	shortest_from_list(InList,TempStream),							/* Calculate shortest paths from list & write to TempStream */
	close(TempStream).												/* Close TempStream */

all_simple:-
	read_var2(Start,'Start-location',Stop,'Stop-location',user),	/* Ask user for start- & stop-location */
	all_simple(Start,Stop).
	
all_simple(Start,Stop):-
	all_from_list([Start,Stop],user).

all_complex:-
	read_var2(InStream,'Inputstream',OutStream,'Outputstream',user),/* Ask user for input- & output-stream */
	all_complex(InStream,OutStream).

all_complex(InStream,OutStream):-
	stream_to_list(InStream,InList),								/* Read stream into list */				
	open(OutStream, write, TempStream),								/* Open TempStream from Outstream to write to */
	all_from_list(InList,TempStream),								/* Calculate all shortest paths & write to OutStream */
	close(TempStream).												/* Close TempStream */


%%%%%%%%%%%%%%%%%%% /*READING*/ %%%%%%%%%%%%%%%%%%%%%%
%/* READ IN 1 VARIABLE */
read_var(Var,Tag,Stream):-
	seeing(Old),													/* Save current stream for later */ 
    see(Stream),													/* See new stream */
    write('Enter '),write(Tag),write(" followed by a point: "),		/* Print message */
	read(Var),														/* Read variable*/ 
    seen,             												/* Close Stream */ 
    see(Old).	    												/* Load previous Stream */
	
%/* READ IN 2 VARIABLLES */
read_var2(Var1,Tag1,Var2,Tag2,Stream):-
	read_var(Var1,Tag1,Stream),										/* Read first variable */
	read_var(Var2,Tag2,Stream).										/* Read second variable */
	
%/* READ STREAM INTO LIST */
stream_to_list(Stream,List) :- 
   see(Stream),														/* See new stream */
   inquire([],R),													/* Gather terms from file */
   reverse(R,List),
   seen.															/* Close Stream */

%/* GATHER TERMS FROM FILE */
inquire(IN,OUT):- 
   read(Data), 
   (Data == end_of_file -> OUT = IN; inquire([Data|IN],OUT) ).


%%%%%%%%%%%%%%%%%%% /* WRITING */ %%%%%%%%%%%%%%%%%%%%
%/* WRITE LIST TO STREAM */
list_to_stream(List,Stream) :-
    \+ loop_through_list(Stream, List).
loop_through_list(Stream, List) :-
    member(Element, List),
	split_head(Element,Path,X),
	member(Distance,X),
	solution_to_stream(Path,Distance,Stream),
    fail.
	
%/* WRITE SOLUTION TO STREAM */
solution_to_stream(Path,Distance,Stream):-
	write(Stream,Path),
	write(Stream,' '),
	write(Stream,Distance),
	writeln(Stream,'km').


%%%%%%%%%%%%%%%%%%% /* ALGORITHMS */ %%%%%%%%%%%%%%%%%
%/* SHORTEST PATH ALGORITHM */
shortestPath(A,B,Path,Length) :-
   setof([P,L],path(A,B,P,L),Set),
   Set = [_|_], % fail if empty
   minimal(Set,[Path,Length]).
minimal([F|R],M) :- 
	min(R,F,M).
min([],M,M).
min([[P,L]|R],[_,M],Min) :- 
	L < M, 
	!, 
	min(R,[P,L],Min). 
min([_|R],M,Min) :- 
	min(R,M,Min).

%/* BEREKEN ALLE PADEN */
path(A,B,Path,Length) :-
    travel(A,B,[A],Q,Length), 
    reverse(Q,Path).
travel(A,B,P,[B|P],L) :-
    connected(A,B,L).
travel(A,B,Visited,Path,L) :-
    connected(A,C,D),           
    C \== B,
    \+member(C,Visited),
    travel(C,B,[C|Visited],Path,L1),
    L is D+L1.


%%%%%%%%%%%%%%%%%%% /* UTILS */ %%%%%%%%%%%%%%%%%%%%%%
%/* CALCULATE SHORTEST PATHS FROM LIST & WRITE TO STREAM*/
shortest_from_list(List,Stream):-
	take_head2(List,Start,Stop,Rest),								/* Take Start en Stop from List */
	shortestPath(Start,Stop,Path,Distance),							/* Invoke shortest path algorithm */
	solution_to_stream(Path,Distance,Stream),						/* Write solution to stream */
	(isEmpty(Rest)-> write('END');shortest_from_list(Rest,Stream)).	/* If remaing list is NOT empty, start over */

%/* CALCULATE ALL PATHS FROM LIST */
all_from_list(List,Stream):-
	take_head2(List,Start,Stop,Rest),								/* Take Start en Stop from List */
	findall([Path,Distance],path(Start,Stop,Path,Distance),Result),	/* Invoke path algorithm */
	list_to_stream(Result,Stream),									/* Write solution to stream */
	(isEmpty(Rest)-> write('END');all_from_list(Rest,Stream)).		/* If remaing list is NOT empty, start over */
	
%/* CHECK IF A LIST IS EMPTY */
isEmpty(List):- not(member(_,List)).

%/* TAKE 2 HEAD-ITEMS FROM LIST */
take_head2(L,A,B,Rest):-
	split_head(L,A,X),
	split_head(X,B,Rest).
	
%/* TAKE HEAD FROM LIST */
split_head([Head|Tail],Head,Tail).