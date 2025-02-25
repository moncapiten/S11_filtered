import tdwf
import matplotlib
matplotlib.use('TkAgg')
import matplotlib.pyplot as plt 
import numpy as np

# -[Configurazione AD2]--------------------------------------------------------
#   1. Connessiene con AD2 e selezione configurazione
ad2 = tdwf.AD2()
ad2.vdd= +5
ad2.vss= -5
ad2.power(True)
#   2. Configurazione generatore di funzioni
wavegen = tdwf.WaveGen(ad2.hdwf)
wavegen.w1.ampl = 0.1
wavegen.w1.freq = 15000
#wavegen.w1.offs = 5
wavegen.w1.phi = 0.0
wavegen.w1.func = tdwf.funcDC
wavegen.w2.config(ampl = 0.3, offs=0, freq=10000.1, phi=0.0, func=tdwf.funcSquare, duty=1)
wavegen.w2.sync()
wavegen.w1.start()
#   3. Configurazione oscilloscopio
scope = tdwf.Scope(ad2.hdwf)
scope.fs = 10e6
scope.npt = 8000
scope.ch1.rng = 5
scope.ch2.rng = 5
scope.ch1.avg = True
scope.ch2.avg = True
scope.trig(True, level=0.0, sour=tdwf.trigsrcCh1, delay=0, hist=0.1)

# -[Funzioni di gestione eventi]-----------------------------------------------

def on_close(event):
    global flag_run
    flag_run = False

def on_scroll(event):
    kk = 1.5  # fattore di zoom/dezoom
    # [1] Calcolo delle coordinate del mouse rispetto agli assi
    x0, x1 = ax.get_xlim()  # limiti asse x
    y0, y1 = ax.get_ylim()  # limiti asse y
    figw, figh = fig.get_size_inches() * fig.dpi  # calcola dimensioni finestra
    box = ax.get_position()  # posizione assi nella finestra
    xdata = (event.x/figw-box.x0)/(box.x1-box.x0)*(x1-x0)+x0
    ydata = (event.y/figh-box.y0)/(box.y1-box.y0)*(y1-y0)+y0
    # [2] del fattore di zoom
    if event.button == 'up':
        factor = 1 / kk
    elif event.button == 'down':
        factor = kk
    else:
        return
    # [3] calcolo delle nuove coordinate limite degli assi
    newdx = (x1-x0) * factor  # nuovo span asse x
    relx = (x1 - xdata) / (x1-x0)  # posizione relativa mouse nello span
    newdy = (y1-y0) * factor  # nuovo span assey
    rely = (y1 - ydata) / (y1-y0)  # posizinoe relativa mouse nello span
    if xdata > x0:  # zoom x
        ax.set_xlim([xdata - newdx * (1-relx), xdata + newdx * (relx)])
    if ydata > y0:   # zoom y
        ax.set_ylim([ydata - newdy * (1-rely), ydata + newdy * (rely)])
    # [4] aggiorna la figura
    fig.canvas.draw()
    fig.canvas.flush_events()

def on_key(event):
    global flag_run, flag_acq, hp1, hp2
    if event.key == 'a':  # autoscale
        ax.set_xlim([tt.min(), tt.max()])
        ax.set_ylim([min(min1.min(), min2.min()), max(max1.max(), max2.max())])
    if event.key == 'x':  # export su file
        filename = input("Esporta dati su file: ")
        data = np.column_stack((scope.time.vals, scope.ch1.vals, scope.ch2.vals))
        info = f"Acquisizione Analog Discovery 2\nTimestamp {scope.time.t0}\ntime\tch1\tch2"
        np.savetxt(filename, data, delimiter='\t', header=info)
    if event.key == '.':  # plot a punti
        hp1.set_linestyle("")
        hp1.set_marker(".")
        hp2.set_linestyle("")
        hp2.set_marker(".")
    if event.key == '-':  # plot a linea
        hp1.set_linestyle("-")
        hp1.set_marker("")
        hp2.set_linestyle("-")
        hp2.set_marker("")
    if event.key == ' ':  # run/pausa
        flag_acq = not flag_acq
    if event.key == 'enter':  # acqusizione singola
        flag_acq = False
        scope.sample()
    if event.key == 'escape':  # termina programma
        flag_run = False

# -[Ciclo di misura]-----------------------------------------------------------
#   1. Creazione figura e link agli eventi
fig, ax = plt.subplots(figsize=(12, 6))
fig.canvas.mpl_connect("close_event", on_close)
fig.canvas.mpl_connect('scroll_event', on_scroll)
fig.canvas.mpl_connect('key_press_event', on_key)
#   2. Creazione dei vettori dei tempi
# (troppi punti, media uno ogni 4)
tt = 1e3*scope.time.vals.reshape(-1, 4).mean(axis=1)
# (vettore degli errori: buffer più corto di un fattore 4)
tte = np.repeat(tt[::4], 2)
tte = np.append(tte[1:]-8e3*scope.time.dt, tte[-1]+8e3*scope.time.dt)
#   3. Ciclo di misura
flag_first = True
flag_acq = True
flag_run = True
while flag_run:
    if flag_acq:  # SE la misura è attiva (space)
        scope.sample()
    # Calcolo dei vettori da visualizzare (vengono fatte alcune medie)
    min1 = np.repeat(scope.ch1.min.reshape(-1, 2).mean(axis=1), 2)
    max1 = np.repeat(scope.ch1.max.reshape(-1, 2).mean(axis=1), 2)
    min2 = np.repeat(scope.ch2.min.reshape(-1, 2).mean(axis=1), 2)
    max2 = np.repeat(scope.ch2.max.reshape(-1, 2).mean(axis=1), 2)
    ch1 = scope.ch1.vals.reshape(-1, 4).mean(axis=1)
    ch2 = scope.ch2.vals.reshape(-1, 4).mean(axis=1)
    if flag_first:
        # Prima esecuzione: creazione grafici
        flag_first = False
        hp1, = plt.plot(tt, ch1, "-", label="Ch1", color="tab:orange")
        hp2, = plt.plot(tt, ch2, "-", label="Ch2", color="tab:blue")
        hp3 = plt.fill_between(tte, min1, max1, color='tab:orange', alpha=0.3)
        hp4 = plt.fill_between(tte, min2, max2, color='tab:blue', alpha=0.3)
        path1 = hp3.get_paths()[0]
        path2 = hp4.get_paths()[0]
        plt.legend()
        plt.grid(True)
        plt.xlabel("Time [msec]", fontsize=15)
        plt.ylabel("Signal [V]", fontsize=15)
        plt.title("User interaction: a|-|.|x|space|enter|escape|scroll")
        plt.show(block=False)
        plt.tight_layout()
        ax.set_xlim([tt.min(), tt.max()])
        #ax.set_ylim([min(min1.min(), min2.min()), max(max1.max(), max2.max())])
    else:
        # Esecuzioni successive: aggiornamento grafici
        hp1.set_ydata(ch1)
        hp2.set_ydata(ch2)
        tmp1 = np.concatenate(([max1[0]], min1, [max1[-1]], max1[::-1], [max1[0]]))
        path1.vertices[:, 1] = tmp1
        tmp2 = np.concatenate(([max2[0]], min2, [max2[-1]], max2[::-1], [max2[0]]))
        path2.vertices[:, 1] = tmp2
        fig.canvas.draw()
        fig.canvas.flush_events()

#   4. Chiude figura e libera AD2
plt.close(fig)
ad2.close()