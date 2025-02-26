import tdwf
import matplotlib
matplotlib.use('TkAgg')
import matplotlib.pyplot as plt 
import numpy as np

# -[Configurazione Analog Discovery 2]-----------------------------------------
#   1. Connessiene con AD2
ad2 = tdwf.AD2()



ad2.vdd = +5
ad2.vss = -5
ad2.power(True)


#   2. Configurazione generatore di funzioni
wgen = tdwf.WaveGen(ad2.hdwf)
#xv = np.linspace(-10,10,1001)
#mydata = np.exp(-10*xv**2)
#wgen.w1.config(ampl = 5, func=tdwf.funcDC, data = mydata)
#wgen.w1.offs = -2
#wgen.w1.freq = 14e3
#wgen.w2.freq = 1e3+0.1
#wgen.w2.sync()
#wgen.w1.start()

wgen.w1.config(func = tdwf.funcDC)
wgen.w1.offs = -1.5
wgen.w1.start()

a = 0

# -[Ciclo di misura]-----------------------------------------------------------
fig, ax = plt.subplots(figsize=(12,6))
fig.canvas.mpl_connect("close_event", on_close)
fig.canvas.mpl_connect('key_press_event', on_key)
flag_run = True
flag_acq = True
flag_first = True
while flag_run:
    if flag_acq: # l'acquisizione è attiva?
        scope.sample()
    # Visualizzazione
    if flag_first:
        flag_first = False
        # Traccia Ch2 in funzione di Ch1
        hp, = plt.plot(scope.ch1.vals, scope.ch2.vals, "-", label="Ch2 vs Ch1", color="tab:green")
        plt.legend()
        plt.grid(True)
        plt.xlabel("Ch1 [V]", fontsize=15)  # Asse x: Canale 1
        plt.ylabel("Ch2 [V]", fontsize=15)  # Asse y: Canale 2
        plt.title("User interaction: x|space|escape")
        plt.tight_layout()
        plt.show(block = False)
        
        # Configura il generatore di segnali
        wgen.w1.config(func = tdwf.funcSine, freq = 700, ampl = .05)
        wgen.w1.start()
    else:
        # Aggiorna i dati del grafico
        hp.set_xdata(scope.ch1.vals)  # Aggiorna i valori dell'asse x (Ch1)
        hp.set_ydata(scope.ch2.vals)  # Aggiorna i valori dell'asse y (Ch2)
        fig.canvas.draw()
        fig.canvas.flush_events()

plt.close(fig)
ad2.close()