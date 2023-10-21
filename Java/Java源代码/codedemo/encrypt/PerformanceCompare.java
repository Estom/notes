package cn.aofeng.demo.encrypt;

import static cn.aofeng.demo.util.LogUtil.log;

import java.io.UnsupportedEncodingException;
import java.security.InvalidAlgorithmParameterException;
import java.security.InvalidKeyException;
import java.security.NoSuchAlgorithmException;

import javax.crypto.BadPaddingException;
import javax.crypto.IllegalBlockSizeException;
import javax.crypto.NoSuchPaddingException;
import javax.crypto.SecretKey;

/**
 * 加密解密性能比较。
 * 
 * @author <a href="mailto:nieyong@ucweb.com">聂勇</a>
 */
public class PerformanceCompare extends EncryptAndDecrypt {

    public void blowfishPerformence(String data)
            throws UnsupportedEncodingException, InvalidKeyException,
            IllegalBlockSizeException, BadPaddingException,
            NoSuchAlgorithmException, NoSuchPaddingException,
            InvalidAlgorithmParameterException {
        Blowfish bf = new Blowfish();
        SecretKey secretKey = createSecretKey(bf.encryptType, bf.key);
        long startTime = System.currentTimeMillis();
        for (int j = 0; j < 100000; j++) {
            bf.encrypt(bf.encryptType, secretKey, data+j);
        }
        long endTime = System.currentTimeMillis();
        long usedTime = endTime - startTime;
        log("使用%s进行%d次加密消耗时间%d毫秒", bf.encryptType, 100000, usedTime);
    }

    public void aesPerformence(String data)
            throws UnsupportedEncodingException, InvalidKeyException,
            IllegalBlockSizeException, BadPaddingException,
            NoSuchAlgorithmException, NoSuchPaddingException,
            InvalidAlgorithmParameterException {
        AES aes = new AES();
        SecretKey secretKey = createSecretKey("AES", aes.key);
        long startTime = System.currentTimeMillis();
        for (int j = 0; j < 100000; j++) {
            aes.encrypt(aes.encryptType, secretKey, data+j,
                    aes.algorithmParam);
        }
        long endTime = System.currentTimeMillis();
        long usedTime = endTime - startTime;
        log("使用%s进行%d次加密消耗时间%d毫秒", aes.encryptType, 100000, usedTime);
    }

    public static void main(String[] args) throws InvalidKeyException,
            UnsupportedEncodingException, IllegalBlockSizeException,
            BadPaddingException, NoSuchAlgorithmException,
            NoSuchPaddingException, InvalidAlgorithmParameterException {
        String data = "炎黄，汉字，english,do it,abcdefghijklmnopqrstuvwxyz,0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ, ~!@#$%^&*()_+=-";
        log("待加密的数据：\n%s", data);

        PerformanceCompare pc = new PerformanceCompare();
        // AES
        pc.aesPerformence(data);

        // Blowfish
        pc.blowfishPerformence(data);
    }

}
