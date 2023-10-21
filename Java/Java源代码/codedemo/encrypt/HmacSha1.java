package cn.aofeng.demo.encrypt;

import static cn.aofeng.demo.util.LogUtil.log;

import java.io.UnsupportedEncodingException;
import java.security.InvalidAlgorithmParameterException;
import java.security.InvalidKeyException;
import java.security.NoSuchAlgorithmException;

import javax.crypto.BadPaddingException;
import javax.crypto.IllegalBlockSizeException;
import javax.crypto.Mac;
import javax.crypto.NoSuchPaddingException;
import javax.crypto.SecretKey;

import org.apache.commons.codec.binary.Base64;

/**
 * HMAC-SHA1签名算法。
 * 
 * @author <a href="mailto:aofengblog@163.com">聂勇</a>
 */
public class HmacSha1 {

    public final String encryptType = "HmacSHA1";
    public final String key = "abcdefgh_1234567";
    
    public void execute(String data) throws UnsupportedEncodingException, 
            NoSuchAlgorithmException, InvalidKeyException {
        EncryptAndDecrypt ead = new EncryptAndDecrypt();
        
        byte[] srcData = data.getBytes(EncryptAndDecrypt.CHARSET);
        SecretKey secretKey = ead.createSecretKey(encryptType, key);   // 生成密钥对象
        Mac mac = Mac.getInstance(encryptType);
        mac.init(secretKey);
        byte[] result = mac.doFinal(srcData);  
        
        log("使用%s签名后的数据：", encryptType);
        log(Base64.encodeBase64String(result));
    }
    
    public static void main(String[] args) throws InvalidKeyException, 
            UnsupportedEncodingException, IllegalBlockSizeException, 
            BadPaddingException, NoSuchAlgorithmException, 
            NoSuchPaddingException, InvalidAlgorithmParameterException {
        String data = "炎黄，汉字，english,do it,abcdefghijklmnopqrstuvwxyz,0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ, ~!@#$%^&*()_+=-";
        log("待签名的数据：\n%s", data);

        HmacSha1 hs = new HmacSha1();
        hs.execute(data);
    }

}
