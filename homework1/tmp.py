from scipy.io.wavfile import read,write
from scipy.signal import stft,istft
from scipy.fft import fft,ifft
from scipy.ndimage import gaussian_filter1d
import numpy as np
import math
import matplotlib.pyplot as plt
tme=10
frq=261
bps=192000
x=np.linspace(0,tme,tme*bps)
y=(np.sin(2*np.pi*frq*x)*30000).astype('int16')
# plt.plot(y)
# plt.show()
write('tmp.wav',bps,y)