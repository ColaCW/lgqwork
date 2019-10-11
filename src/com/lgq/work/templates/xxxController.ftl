package com.lgq.common.controller;

import com.lgq.common.dao.SystemMenuSQL;
import com.lgq.common.obj.SystemMenuObj;

import com.lgq.common.obj.UserObj;

import com.alibaba.fastjson.JSON;
import com.lgq.app.obj.ResultObj;
import com.lgq.common.util.AppUtil;
import com.lgq.common.util.StringUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.data.domain.Sort.Direction;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import javax.persistence.criteria.CriteriaBuilder;
import javax.persistence.criteria.CriteriaQuery;
import javax.persistence.criteria.Predicate;
import javax.persistence.criteria.Root;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping(value = "/api/SystemMenu")
@CrossOrigin(allowCredentials="true",origins = "*",maxAge = 3600)
public class SystemMenuController {

	public static SystemMenuSQL systemMenuSQL;
	@Autowired
    public void setSystemMenuSQL(SystemMenuSQL systemMenuSQL) {  
		SystemMenuController.systemMenuSQL = systemMenuSQL;
    } 
	
	@RequestMapping(value = "/create.do")
	public ResultObj create(HttpSession session, HttpServletRequest request, HttpServletResponse response) {
		ResultObj result = new ResultObj();
		try {
			Map<String, String> param = AppUtil.getBodyParams(request);
			SystemMenuObj obj = JSON.parseObject(param.get("obj"),SystemMenuObj.class);
			String token = param.get("token");
			UserObj user = AppUtil.getUser(token);
			if(user != null) {
				obj.setCreateAt(StringUtil.getFormatDate(new Date(), "yyyy-MM-dd HH:mm:ss"));
				obj.setCreateBy(user.getId());
				obj.setDeleteBy("0");
				systemMenuSQL.save(obj);
				result.setData(obj);
				result.setStatus(true);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return result;
	}
	
	@RequestMapping(value = "/delete.do")
	public ResultObj delete(HttpSession session, HttpServletRequest request, HttpServletResponse response) {
		ResultObj result = new ResultObj();
		try {
			Map<String, String> param = AppUtil.getBodyParams(request);
			String token = param.get("token");
			String ids = param.get("id");
			if(!StringUtil.isEmpty(token)) {
				UserObj user = AppUtil.getUser(token);
				if(user != null && !StringUtil.isEmpty(ids)) {
					String[] idArray = ids.split(",");
					for(int i = 0;i<idArray.length;i++) {
						SystemMenuObj obj = systemMenuSQL.findById(Integer.parseInt(idArray[i])).get();
						if(obj != null) {
							obj.setDeleteAt(StringUtil.getFormatDate(new Date(),"yyyy-MM-dd HH:mm:ss"));
							obj.setDeleteBy(user.getId());
							systemMenuSQL.save(obj);
						}
					}
					result.setStatus(true);
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return result;
	}

	@RequestMapping(value = "/update.do")
	public ResultObj update(HttpSession session, HttpServletRequest request, HttpServletResponse response) {
		ResultObj result = new ResultObj();
		try {
			Map<String, String> param = AppUtil.getBodyParams(request);
			SystemMenuObj obj = JSON.parseObject(param.get("obj"),SystemMenuObj.class);
			String token = param.get("token");
			UserObj user = AppUtil.getUser(token);
			if(user != null) {
				obj.setUpdateAt(StringUtil.getFormatDate(new Date(), "yyyy-MM-dd HH:mm:ss"));
				obj.setUpdateBy(user.getId());
				systemMenuSQL.save(obj);
				result.setStatus(true);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return result;
	}
	
	@RequestMapping(value = "/read.do")
	public ResultObj read(HttpSession session, HttpServletRequest request, HttpServletResponse response) {
		ResultObj result = new ResultObj();
		try {
			Map<String, String> param = AppUtil.getBodyParams(request);
			String token = param.get("token");
			String id = param.get("id");
			UserObj user = AppUtil.getUser(token);
			if(user != null) {
				if(!StringUtil.isEmpty(id)) {
					SystemMenuObj obj = systemMenuSQL.findById(Integer.parseInt(id)).get();
					if(obj != null) {
						result.setData(obj);
						result.setStatus(true);
					}
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return result;
	}
	
	@RequestMapping(value = "/search.do")
	public ResultObj search(HttpSession session, HttpServletRequest request, HttpServletResponse response) {
		ResultObj result = new ResultObj();
		try {
			Map<String, String> param = AppUtil.getBodyParams(request);
			int page = StringUtil.getInteger(param.get("page"),0);
			int pageSize = StringUtil.getInteger(param.get("pageSize"),0);
			String id =  StringUtil.getString(param.get("id"),"");
			String name = StringUtil.getString(param.get("name"),"");
			Sort sort=new Sort(Direction.ASC,"seq");
			if(page == 0) {
				List<SystemMenuObj> data = systemMenuSQL.findByDeleteBy("0",sort);
				result.setData(data);
			    result.setStatus(true);
			}else {
				Pageable pageable = new PageRequest(page-1, pageSize, sort);
				Page<SystemMenuObj> data = systemMenuSQL.findAll(new Specification<SystemMenuObj>(){
		            @Override
		            public Predicate toPredicate(Root<SystemMenuObj> root, CriteriaQuery<?> query, CriteriaBuilder criteriaBuilder) {
		                List<Predicate> predicates  = new ArrayList<Predicate>();
		                predicates.add(criteriaBuilder.equal(root.get("deleteBy"), "0"));
		                if(!StringUtil.isEmpty(id)) {
		                	predicates.add(criteriaBuilder.equal(root.get("id"), id));	
		                }
		                if(!StringUtil.isEmpty(name)) {
		                	predicates.add(criteriaBuilder.like(root.get("name"), "%" + name + "%"));	
		                }
		                return criteriaBuilder.and(predicates.toArray(new Predicate[predicates.size()]));
		            }
		        },pageable);
			    result.setData(data);
			    result.setStatus(true);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return result;
	}
}
