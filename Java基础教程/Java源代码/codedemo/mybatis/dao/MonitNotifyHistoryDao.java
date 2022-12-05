package cn.aofeng.demo.mybatis.dao;

import org.apache.ibatis.session.SqlSession;
import org.apache.ibatis.session.SqlSessionFactory;

import cn.aofeng.demo.mybatis.entity.MonitNotifyHistory;

/**
 * 监控通知历史CURD。
 * 
 * @author <a href="mailto:aofengblog@163.com">聂勇</a>
 */
public class MonitNotifyHistoryDao {
    
    private SqlSessionFactory _ssFactory = null;
    
    public MonitNotifyHistoryDao(SqlSessionFactory factory) {
        this._ssFactory = factory;
    }

    private String assembleStatement(String id) {
        return "cn.aofeng.demo.mybatis.dao.MonitNotifyHistoryMapper."+id;
    }
    
    private void close(SqlSession session) {
        if (null != session) {
            session.close();
        }
    }
    
    public int deleteByPrimaryKey(Long recordId) {
        SqlSession session = _ssFactory.openSession(true);
        int result = 0;
        try {
            session.delete(assembleStatement("deleteByPrimaryKey"), recordId);
        } finally {
            close(session);
        }
        
        return result;
    }

    public int insert(MonitNotifyHistory record) {
        SqlSession session = _ssFactory.openSession(true);
        int result = 0;
        try {
            result = session.insert(assembleStatement("insertSelective"), record);
        } finally {
            close(session);
        }
        
        return result;
    }
    
    public MonitNotifyHistory selectByPrimaryKey(Long recordId) {
        SqlSession session = _ssFactory.openSession();
        MonitNotifyHistory result = null;
        try {
            result = session.selectOne(assembleStatement("selectByPrimaryKey"), recordId);
        } finally {
            close(session);
        }
        
        return result;
    }

    public int updateByPrimaryKeySelective(MonitNotifyHistory record) {
        SqlSession session = _ssFactory.openSession(true);
        int result = 0;
        try {
            session.update(assembleStatement("updateByPrimaryKeySelective"), record);
        } finally {
            close(session);
        }
        
        return result;
    }

}