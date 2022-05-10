import psycopg2
import pandas as pd 
import gspread 

gc = gspread.service_account(filename="neon-slate-349814-a8e5485886d1.json")

connection=psycopg2.connect(
        host="localhost",
        user="postgres", 
        password="Red_21/Dash",
        database="PRUEBA_URBVAN")
    

Viajes = pd.read_sql("SELECT * FROM Viajes_Nov_Acum", connection)


#sh = gc.create("Prueba2")
#mail="datpyed11@gmail.com"
#sh.share(mail, perm_type="user", role="writer")
Viajes = pd.DataFrame(Viajes)
Viajes["departure_at"] = Viajes["departure_at"].astype("string")
Viajes["arrival_at"] = Viajes["arrival_at"].astype("string")

sh = gc.open("Prueba2")
primera_hoja = sh.get_worksheet(0)
primera_hoja.update([Viajes.columns.values.tolist()] + Viajes.values.tolist())