const int digital_10 = 10; const int digital_11 = 11; 
const int digital_12 = 12; const int digital_13 = 13;
const int digital_4 = 4; const int digital_5 = 5;
const int digital_6 = 6; const int digital_7 = 7;
const int atraso = 15;
int x;  int y=0;
int x1; int y1=0;
int h=1;
int leitura=0; int leitura2=0;
int tam_maior=0; int tam_menor=0; int qual_maior=0;

const int matrix[4][4]  = {{LOW,LOW,HIGH,HIGH},
                           {LOW,HIGH,HIGH,LOW},
                           {HIGH,HIGH,LOW,LOW},
                           {HIGH,LOW,LOW,HIGH}};

void four(){
  digitalWrite(digital_13, HIGH);
  digitalWrite(digital_12, HIGH);
  delay(atraso);                    
  digitalWrite(digital_13, LOW);
  digitalWrite(digital_12, LOW);
}
void three(){
  digitalWrite(digital_11, HIGH);
  digitalWrite(digital_12, HIGH);  
  delay(atraso);                      
  digitalWrite(digital_11, LOW);   
  digitalWrite(digital_12, LOW);
}
void two(){
  digitalWrite(digital_10, HIGH);
  digitalWrite(digital_11, HIGH);  
  delay(atraso);                      
  digitalWrite(digital_11, LOW); 
  digitalWrite(digital_10, LOW);
}
void one(){
  digitalWrite(digital_13, HIGH);
  digitalWrite(digital_10, HIGH);  
  delay(atraso);                     
  digitalWrite(digital_13, LOW); 
  digitalWrite(digital_10, LOW);
}
void four1(){
  digitalWrite(digital_7, HIGH);  
  digitalWrite(digital_6, HIGH);  
  delay(atraso);                     
  digitalWrite(digital_7, LOW);   
  digitalWrite(digital_6, LOW); 
}
void three1(){
  digitalWrite(digital_5, HIGH);  
  digitalWrite(digital_6, HIGH);  
  delay(atraso);                      
  digitalWrite(digital_5, LOW);   
  digitalWrite(digital_6, LOW);
}
void two1(){
  digitalWrite(digital_5, HIGH);  
  digitalWrite(digital_4, HIGH);  
  delay(atraso);                      
  digitalWrite(digital_5, LOW);   
  digitalWrite(digital_4, LOW);
}
void one1(){
  digitalWrite(digital_4, HIGH);  
  digitalWrite(digital_7, HIGH);  
  delay(atraso);                      
  digitalWrite(digital_4, LOW);
  digitalWrite(digital_7, LOW);
}
void setup(){
  Serial.begin(9600);
}
void original1(){
  if(x1==1){
    if(y1==0){
      one1(); 
      y1=1;
    }
    else{    
      if(y1==1){
        two1();
        y1=2;
      }
      else{
        if(y1==2){
          three1();
          y1=3;
        }
        else{
          four1();
          y1=0;
        }
      }
    }
  }
  if(x1==-1){
    if(y1==0){
      three1(); 
      y1=3;
    }
    else{    
      if(y1==3){
        two1();
        y1=2;
      }
      else{
        if(y1==2){
          one1();
          y1=1;
        }
        else{
          four1();
          y1=0;
        }
      }
    }
  }
}
void original(){
  if(x==1){
    if(y==0){
      one(); 
      y=1;
    }
    else{    
      if(y==1){
        two();
        y=2;
      }
      else{
        if(y==2){
          three();
          y=3;
        }
        else{
          four();
          y=0;
        }
      }
    }
  }
  if(x==-1){
    if(y==0){
      three(); 
      y=3;
    }
    else{    
      if(y==3){
        two();
        y=2;
      }
      else{
        if(y==2){
          one();
          y=1;
        }
        else{
          four();
          y=0;
        }
      }
    }
  }
}
void loop() {
  if(Serial.available()>0){
      leitura = Serial.parseInt();
      leitura2 = Serial.parseInt();
      Serial.read();
      Serial.println(String(leitura));
      //Serial.println(String(leitura2));
      if(leitura>0){
        x=1;
      }
      else{
        x=-1;
        leitura=-leitura;
      }
      if(leitura2>0){
        x1=1;
      }
      else{
        x1=-1;
        leitura2=-leitura2;
      }
      if(leitura>leitura2){
        tam_maior=leitura;
        tam_menor=leitura2;
        qual_maior=0;
      }
      else{
        tam_maior=leitura2;
        tam_menor=leitura;
        qual_maior=1;
      }
      if(tam_maior){
        for(int i=0;i<tam_maior;i++){
          if(qual_maior){
            original1();
            if(i<tam_menor){
              original();
            }
          }
          else{
            original();
            if(i<tam_menor){
              original1();
            }
          }
        }
      }
     //Serial.read();
  }              
}