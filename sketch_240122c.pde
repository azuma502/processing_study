import ddf.minim.*;
import ddf.minim.analysis.*;

Minim minim;
AudioPlayer player;
FFT fft;

PImage img;
int Y = 0;
float sensib = 1.5; 
float scale;
int step = 10; 
int bufferSize =512;
int currentStrokeColor;

void setup() {
    size(800, 800, P2D); 
    background(0);
    img = createImage(width, height, RGB); // PImageの初期化

    minim = new Minim(this);
    player = minim.loadFile("SPECIALZ.mp3", 1024);
    player.play();

    fft = new FFT(player.bufferSize(), player.sampleRate());
    fft.logAverages(22, 3);
   
    
     currentStrokeColor = color(255, 0, 0, 30);
    
    
}

void draw() {
    background(0); // 背景色を黒に設定

    if (player.isPlaying()) {
        fft.forward(player.mix);

        if (frameCount > 6) {
            copy(img, 0, 2, width, height, 0, 0, width, height);
        }
        
        int time = millis(); // 経過時間をミリ秒で取得
        int colorChangeInterval = 3000; // 色を変更する間隔（ここでは10000ミリ秒、つまり10秒）

          if (time % (2 * colorChangeInterval) < colorChangeInterval) {
            currentStrokeColor = color(255, random(0, 100), random(0, 100), 30); // 赤色
        } else {
            if (time % colorChangeInterval < 50) { 
                currentStrokeColor = color(random(0, 100), random(0, 100), random(100, 255), 50);
            }
        }

        stroke(currentStrokeColor);
        noFill();
         strokeWeight(2);

        beginShape();
        float firstX = map(0, 0, fft.avgSize()-1, 0, width+700);
        float firstY = Y - fft.getAvg(0) * sensib;
        curveVertex(firstX, firstY);

        // FFTデータに基づいて曲線を描画
        for (int i = 0; i < fft.avgSize(); i++) {
            float x = map(i, 0, fft.avgSize()-1, 0, width+700);
            float y = Y - fft.getAvg(i) * sensib;
            curveVertex(x, y);
        }

        // 曲線の終了点の後に制御点を追加
        float lastX = map(fft.avgSize() - 1, 0, fft.avgSize()-1, 0, width+700);
        float lastY = Y - fft.getAvg(fft.avgSize() - 1) * sensib;
        curveVertex(lastX, lastY);
        endShape();

        
        img = get(); // 現在のフレームを画像として取得

        if (Y < height - 120) {
            Y += 3;
        }
        
    }
}
