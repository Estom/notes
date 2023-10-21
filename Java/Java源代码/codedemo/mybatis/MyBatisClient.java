package cn.aofeng.demo.mybatis;

import java.io.IOException;
import java.io.InputStream;

import org.apache.ibatis.io.Resources;
import org.apache.ibatis.session.SqlSessionFactory;
import org.apache.ibatis.session.SqlSessionFactoryBuilder;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import cn.aofeng.demo.mybatis.dao.MonitNotifyHistoryDao;
import cn.aofeng.demo.mybatis.entity.MonitNotifyHistory;

/**
 * 
 * 
 * @author <a href="mailto:aofengblog@163.com">聂勇</a>
 */
public class MyBatisClient {

    private static Logger _logger = LoggerFactory.getLogger(MyBatisClient.class);
    
    public static void main(String[] args) throws IOException {
        String resource = "mybatis-config.xml";
        InputStream ins = Resources.getResourceAsStream(resource);
        SqlSessionFactory ssFactory = new SqlSessionFactoryBuilder().build(ins);
        MonitNotifyHistoryDao dao = new MonitNotifyHistoryDao(ssFactory);
        
        // 插入一条记录
        long recordId = 999;
        MonitNotifyHistory record = new MonitNotifyHistory();
        record.setRecordId(recordId);
        record.setMonitId(9999);
        record.setAppId(99);
        record.setNotifyTarget(1);
        record.setNotifyType(1);
        record.setNotifyContent("通知内容测试");
        record.setStatus(0);
        record.setCreateTime(1492061400000L);
        int count = dao.insert(record);
        _logger.info("insert complete, effects {} rows", count);
        
        // 查询记录
        MonitNotifyHistory entity = dao.selectByPrimaryKey(recordId);
        _logger.info("query record id {}, result: {}", recordId, entity);
        
        // 更新一个字段再执行查询
        entity.setRetryTimes(99);
        count = dao.updateByPrimaryKeySelective(entity);
        _logger.info("update complete, record id:{}, effects {} rows", recordId, count);
        entity = dao.selectByPrimaryKey(recordId);
        _logger.info("query record id {}, result: {}", recordId, entity);
        
        // 删除记录后再执行查询
        count = dao.deleteByPrimaryKey(recordId);
        _logger.info("delete complete, record id {}, effects {} rows", recordId, count);
        entity = dao.selectByPrimaryKey(recordId);
        _logger.info("query record id {}, result: {}", recordId, entity);
    }

}
