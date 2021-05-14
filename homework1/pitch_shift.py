from scipy.io.wavfile import read,write
from scipy.signal import stft,istft
from scipy.fft import fft,ifft
from scipy.ndimage import gaussian_filter1d
import numpy as np
import matplotlib.pyplot as plt
framerate,audio=read('list1M_01.wav')
plt.plot(audio)
plt.show()
time_audio=len(audio)/framerate
min_time=0.02
len_seg=int(min_time*framerate)
f,t,Zxx=stft(audio,nperseg=len_seg,noverlap=int(len_seg*0.8),window='hamming')
f*=framerate
t=np.linspace(0,time_audio,len(t))

nw=np.zeros_like(Zxx)
for i in range(5,Zxx.shape[0]):
	nw[i]=Zxx[i-3]
out=(istft(nw,nperseg=len_seg,noverlap=int(len_seg*0.8),window='hamming')[1]).astype('int16')
plt.plot(out)
plt.show()
write('out.wav',framerate,out)

img=plt.pcolormesh(t,f[:50],2*np.log(np.abs(Zxx)+1e-6)[:50],vmin=-5,vmax=15,shading='auto')
plt.title('Original')
plt.colorbar(img,label='energy(db)')
plt.ylabel('Frequency [Hz]')
plt.xlabel('Time [sec]')
plt.show()

img=plt.pcolormesh(t,f[:50],2*np.log(np.abs(nw)+1e-6)[:50],vmin=-5,vmax=15,shading='auto')
plt.title('Pitch shifted')
plt.colorbar(img,label='energy(db)')
plt.ylabel('Frequency [Hz]')
plt.xlabel('Time [sec]')
plt.show()

