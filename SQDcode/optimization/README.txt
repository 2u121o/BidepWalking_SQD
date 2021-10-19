

addpath.m --> aggiunge i path di yalmip in modo da poterlo utilizzare in altre cartelle

generate_references.m --> genera i ZMP x e y e i relativi support polygon e plotta 
						  la sequenza di passi nel piano xy
						
optimizationporblemx.m --> risolve il problema di ottimizzazione (10) del paper
						   e plotta le traiettorie dello ZMP e del CoM sia nello 
						   spazio che nel tempo
						
optimizationporblemy.m --> risolve il problema di ottimizzazione vincolata con 
						   MPC per generare la traiettoria del CoM e dello ZMP 
						   lungo l'asse y. Prende come riferimento la traiettoria 
						   dello ZMP calcolata con i tempi trovati con l'ottimizzazione
						   nello spazio. Viene utilizzato il modello dianmico LIP + 
						   estensione 
SQDsagittal_beta50.mat --> workspace nel caso dell'ottimizzazione con il peso beta=50

SQDsagittal_beta1.5.mat --> workspace nel caso dell'ottimizzazione con il peso beta=1.5
