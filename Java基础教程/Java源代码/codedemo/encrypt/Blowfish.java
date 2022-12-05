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

import org.apache.commons.codec.binary.Base64;

/**
 * Blowfish加密解密。
 * 
 * @author <a href="mailto:aofengblog@163.com">聂勇</a>
 */
public class Blowfish extends EncryptAndDecrypt {

    public final String encryptType = "Blowfish";
    public final String key = "abcdefgh_1234567";

    public void execute(String data) throws InvalidKeyException,
            IllegalBlockSizeException, BadPaddingException,
            UnsupportedEncodingException, NoSuchAlgorithmException,
            NoSuchPaddingException, InvalidAlgorithmParameterException {
        SecretKey secretKey = createSecretKey(encryptType, key);
        byte[] secretData = encrypt(encryptType, secretKey, data);
        log("使用%s加密后的数据：", encryptType);
        log(Base64.encodeBase64String(secretData));

        String srcStr = decrypt(encryptType, secretKey, secretData);
        log("解密后的数据：\n%s", srcStr);
    }

    public static void main(String[] args) throws UnsupportedEncodingException,
            InvalidKeyException, IllegalBlockSizeException,
            BadPaddingException, NoSuchAlgorithmException,
            NoSuchPaddingException, InvalidAlgorithmParameterException {
        String data = "炎黄，汉字，english,do it,abcdefghijklmnopqrstuvwxyz,0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ, ~!@#$%^&*()_+=-";
        log("待加密的数据：\n%s", data);

        Blowfish bf = new Blowfish();
        bf.execute(data);
    }

}
