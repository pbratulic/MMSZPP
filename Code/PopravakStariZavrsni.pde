import java.util.ArrayList;
import java.util.List;

//lista pitanja
ArrayList<Pitanje> listaPitanja = new ArrayList();
ArrayList<Pitanje> listaTocnihPitanja = new ArrayList();
int indeksPitanja = 0;
int tocnoOdg;
int h =0;
ArrayList<Pitanje> pomocnaLista = new ArrayList();
String[] slike = {"slon.jpg","jelacic.jpg","gruzija.jpg","omis.jpg","more.jpg","motika.jpg"};
PImage toShow;

//status programa, opcije:
final int uTijeku=0;
final int kraj=1;
final int odgovorenoPitanje=2;
final int odabirIgre = 3;
final int odabirVrste = 4;
final int uTijekuVrijeme=5;
//trenutni status označvam varijablom status
int status = odabirVrste; 
int prethStatus = odabirVrste;

int vrijeme;
int cekaj = 1500;
int odbrojavanje = 10000;
int ispis = 0;
int sekZaIspis;
int staroVrijeme;
int bodovi = 0;
int brojPitanja = 0;

//boolean otkucaj = false;
//sva pitanja spremim u polje
String[] poljePitanja;
//int[] tocniOdgovori={1,3,4,4,2,1,3,4,2,4,1,2,4,3,1,2,3,2,4,2};

void setup(){
  size(800,500);
  vrijeme = millis();
  tocnoOdg=0;
  //println(otkucaj);
  poljePitanja = loadStrings("pitanja.txt");
  //println("there are " + poljePitanja.length + " lines");
  //for(int i = 0 ; i < poljePitanja.length; i++) {
  //  println(poljePitanja[i]);
  //}
  int i2 = 0;
  for (int i=0; i<poljePitanja.length; i+=7)
  {
    Pitanje trenutnoPitanje = new Pitanje(poljePitanja[i], poljePitanja[i+1],poljePitanja[i+2], poljePitanja[i+3],poljePitanja[i+4],poljePitanja[i+5],poljePitanja[i+6], 30, 30);
    pomocnaLista.add(trenutnoPitanje);
    i2++;
  }
   //za shuffle arrayliste
   // Collections.shuffle(listaPitanja);
   
   while(listaPitanja.size()< 10)
   {
     int indeks = (int)random(pomocnaLista.size());
     listaPitanja.add(pomocnaLista.get(indeks));
     pomocnaLista.remove(indeks);
   }
    
    
}

void draw() {
  background(220);
  int brojTocnihPitanja = listaTocnihPitanja.size();
  int ukupnoPitanja= listaPitanja.size();
  
  
  switch(status) {
    
    case odabirVrste:
      textSize(32);
      text("Dobrodošli u kviz!",50,50);
      textSize(24);
      text("Odaberite vrstu igre:", 50, 100);
      textSize(16);
      text("Normal [N]:", 50, 150);// za sada pritiskom na tipku
      text("Time Rush [T]:", 50, 250);
      break;
      
    case uTijeku:
      listaPitanja.get(indeksPitanja).display(indeksPitanja, tocnoOdg);
      break;
      
    case uTijekuVrijeme:
      listaPitanja.get(indeksPitanja).display(indeksPitanja, tocnoOdg);
      text("Broj ostvarenih bodova "+bodovi, 30, 300);
      text("Preostalo vremena: ", 30, 330);
      int milisekunde = millis()-vrijeme;
      //print(milisekunde);
      if(ispis == 0){
        //print(milisekunde);
        ispis = 1;
        staroVrijeme = milisekunde;
        sekZaIspis = 10;
      }
      else if(ispis == 1 && milisekunde > staroVrijeme + 1000){
        staroVrijeme = milisekunde;
        sekZaIspis--;
        text(sekZaIspis + " sekundi", 200, 330);
      }
      if(ispis == 1){
        text(sekZaIspis + " sekundi", 200, 330);
      }
      if(millis()-vrijeme>=odbrojavanje)
      {
        status = odgovorenoPitanje;
        prethStatus = uTijekuVrijeme;
        //otkucaj = true;
        vrijeme = millis();
        //if(h==1) tocnoOdg++;
        ispis = 0;
      }
      break;
      
    case odgovorenoPitanje:
      
      //ako je tocno ----- inače ----
      if(listaPitanja.get(indeksPitanja).check(key))
      {
        fill(39,185,208);
        textSize(16);
        listaTocnihPitanja.add(listaPitanja.get(indeksPitanja));
        text("Točan odgovor", 100,50);
        h=1;
        ispis = 0;
      }
      else
      {
        h=0;
        ispis = 0;
        fill(39,185,208);
        textSize(16);
        text("Netočan odgovor", 100,50);
      }
       if(millis()-vrijeme>=cekaj)
      {
      status = prethStatus;
      indeksPitanja++;
      //otkucaj = true;
      vrijeme = millis();
      if(h==1){
        tocnoOdg++;
        if(prethStatus == uTijekuVrijeme){
          bodovi += sekZaIspis;
        }
      }
      }
      if(indeksPitanja>listaPitanja.size()-1)
      {
        status = kraj;
      }
       break;
       
    case kraj:
   
      fill(11,138,6);
      textSize(18);
      text("Kviz je završio.Točno ste odgovorili na "+tocnoOdg+" pitanja od "+ukupnoPitanja+".", 100, 100);
      if(prethStatus == uTijekuVrijeme){
        text("Vaš rezultat je "+bodovi+".", 100, 150);
      }
      text("Kliknite R za ponovo igranje",100,200);
      
  }
}

void keyPressed()
{
  switch(status) {
    case odabirVrste:
    if(key == 'n' || key == 'N')
    {
      status = uTijeku;
    }
    if(key == 't' || key == 'T')
    {
      status = uTijekuVrijeme;
      vrijeme = millis();
    }
    break;
    case uTijeku:
      if(key>='1' && key <='4')
      {
        status = odgovorenoPitanje;
        prethStatus = uTijeku;
        vrijeme = millis();
      }
      break;
    case uTijekuVrijeme:
      if(key>='1' && key <='4')
      {
        status = odgovorenoPitanje;
        prethStatus = uTijekuVrijeme;
        vrijeme = millis();
      }
      break;
    case odgovorenoPitanje:
      status = prethStatus;
      if(status == uTijekuVrijeme)
        vrijeme = millis();
     // indeksPitanja++;
      if(indeksPitanja>listaPitanja.size()-1)
      {
        status = kraj;
      }
      
      break;
     case kraj:
       if(key == 'r' || key == 'R') {
         indeksPitanja=0;
         status=odabirVrste;
         tocnoOdg=0;
         bodovi = 0;
         ispis = 0;
         int i2=0;
         
        pomocnaLista= new ArrayList();
        listaPitanja= new ArrayList();
        for (int i=0; i<poljePitanja.length; i+=7)
        {
          Pitanje trenutnoPitanje = new Pitanje(poljePitanja[i], poljePitanja[i+1],poljePitanja[i+2], poljePitanja[i+3], poljePitanja[i+4], poljePitanja[i+5], poljePitanja[i+6], 30, 30);
          pomocnaLista.add(trenutnoPitanje);
          i2++;
          }

        while(listaPitanja.size()< 10)
        {
         int indeks = (int)random(pomocnaLista.size());
         listaPitanja.add(pomocnaLista.get(indeks));
         pomocnaLista.remove(indeks);
        }
       }
       break;
     default:
       break;  
  }
  
}

class Pitanje {
  String tekstPitanja;
  String[] odgovori;
  int tocanOdgovor;
  int pozicijaX, pozicijaY;
  String slika;
  int tip;
  
  Pitanje(String tp, String o1, String o2, String o3, String o4, String tocan, String slikaP, int x, int y)
  {
    tekstPitanja = tp;

    odgovori = new String[4];
    odgovori[0] = o1;
    odgovori[1] = o2;
    odgovori[2] = o3;
    odgovori[3] = o4;
    
    tocanOdgovor = Integer.parseInt(tocan);
    pozicijaX = x;
    pozicijaY = y;
    tocnoOdg=0;
    tip = 0;
    int found = 0;
    for(int i = 0; i<slike.length;++i){
      if(slikaP.equals(slike[i])==true){
        slika = slikaP;
        tip = 1;
      }
    }
    //if(found == 0)
    //slika = slikaP;
  }
  
  void display(int indeksPitanja,int tocnoOdgovoreni) {
    fill(0,150,105);
    rect(pozicijaX-10,pozicijaY-25,700,30);
    fill(210,7,7);
    textSize(20);
    text(tekstPitanja, pozicijaX, pozicijaY);
    
    for(int i = 0; i<4; ++i){
      fill(0,150,175);
      rect(pozicijaX-10,pozicijaY-25+30*(i+1),700,30);
      
      fill(0,102,150);
      textSize(16);
      text(" "+ (i+1) +".) "+odgovori[i], pozicijaX, pozicijaY+30*(i+1));
    }
    //print(tip);
    if (tip == 1){
      //if(ispis == 0){
        toShow = loadImage(slika);
        toShow.resize(250,250);
        image(toShow,400,180);
        // ono s resize mozda ?
      //}
    }
    
    fill(0);
    textSize(13);
    text("Na tipkovnici odaberi broj uz točan odgovor.", pozicijaX, pozicijaY+150);
    
    text("Pitanje broj "+(indeksPitanja+1), pozicijaX, pozicijaY+200);
    text("Broj točno odgovorenih pitanja dosad "+tocnoOdgovoreni, pozicijaX, pozicijaY+230);
  }
  
  boolean check(char keyToTest) {
    if(keyToTest=='1' && tocanOdgovor==1)  return true;
    if(keyToTest=='2' && tocanOdgovor==2)  return true; 
    if(keyToTest=='3' && tocanOdgovor==3)  return true; 
    if(keyToTest=='4' && tocanOdgovor==4)  return true; 
    return false;
  }
  
  
}
