# Progetto Reti Logiche

Progetto del corso di Reti Logiche del Prof. William Fornaciari, effettuato durante l'anno accademico 2018/2019 al Politecnico di Milano

## Descrizione generale
Sia dato uno spazio bidimensionale definito in termini di dimensione orizzontale e verticale,
e siano date le posizioni di N punti, detti “centroidi”, appartenenti a tale spazio. Si vuole
implementare un componente HW descritto in VHDL che, una volta fornite le coordinate di
un punto appartenente a tale spazio, sia in grado di valutare a quale/i dei centroidi risulti più
vicino (Manhattan distance).
Lo spazio in questione è un quadrato (256x256) e le coordinate nello spazio dei centroidi e
del punto da valutare sono memorizzati in una memoria (la cui implementazione non è parte
del progetto). La vicinanza al centroide viene espressa tramite una maschera di bit
(maschera di uscita) dove ogni suo bit corrisponde ad un centroide: il bit viene posto a 1 se il
centroide è il più vicino al punto fornito, 0 negli altri casi. Nel caso il punto considerato risulti
equidistante da 2 (o più) centroidi, i bit della maschera d’uscita relativi a tali centroidi
saranno tutti impostati ad 1.
Degli N centroidi K<=N sono quelli su cui calcolare la distanza dal punto dato. I K centroidi
sono indicati da una maschera di ingresso a N bit: il bit a 1 indica che il centroide è valido
(punto dal quale calcolare la distanza) mentre il bit a 0 indica che il centroide non deve
essere esaminato. Si noti che la maschera di uscita è sempre a N bit e che i bit a 1 saranno
non più di K.
### Dati
I dati ciascuno di dimensione 8 bit sono memorizzati in una memoria con indirizzamento al
Byte partendo dalla posizione 0.
- L’indirizzo 0 è usata per memorizzare il numero di centroidi (Maschera di ingresso:
definisce quale centroide deve essere esaminato);
- Gli indirizzi dal 1 al 16 sono usati per memorizzare le coordinate a coppie X e Y dei
centroidi:
- 1 - Coordinata X 1 o Centroide
- 2 - Coordinata Y 1 o Centroide
- 3 - Coordinata X 2 o Centroide
- 4 - Coordinata Y 2 o Centroide
- …
- 15 - Coordinata X 8 o Centroide
- 16 - Coordinata Y 8 o Centroide
- Gli indirizzi 17 e 18 sono usati per memorizzare le Coordinate X e Y del punto da
valutare
- L’indirizzo 19 è usato per scrivere, alla fine, il valore della maschera di uscita.

#### Note ulteriori sulla specifica
1. I centroidi nella maschera vengono elencati dal bit meno significativo -posizione più a
destra - (Centroide 1) al più significativo (Centroide 8);
2. Il valore della maschera risultante dall’identificazione del/dei centroide/i più vicino/i
segue la stessa regola vista al punto precedente. Il bit meno significativo rappresenta
il Centroide 1 mentre quello più significativo il Centroide 8;
3. Il modulo partirà nella elaborazione quando un segnale START in ingresso verrà
portato a 1. Il segnale di START rimarrà alto fino a che il segnale di DONE non verrà
portato alto; Al termine della computazione (e una volta scritto il risultato in memoria),
il modulo da progettare deve alzare (portare a 1) il segnale DONE che notifica la fine
dell’elaborazione. Il segnale DONE deve rimanere alto fino a che il segnale di START
non è riportato a 0. Un nuovo segnale start non può essere dato fin tanto che DONE
non è stato riportato a zero.
