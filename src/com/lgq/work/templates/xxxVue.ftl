<template>
  <div class="container">
    <!--表格数据-->
    <div class="table">
      <div class="tableHead">
        <div class="btnGroup" v-if="rule">
          <el-button type="primary" size="medium" icon="el-icon-search"  @click="searchDialogStatus = true" >查询
          </el-button>
          <el-button type="primary" size="medium" icon="el-icon-plus"  @click="addDialogStatus = true;resetForm('addform');" >新增
          </el-button>
          <el-button type="primary" size="medium" icon="el-icon-delete"  @click="doDelete()" >删除
          </el-button>
        </div>
      </div>
      <baseTable ref="table" style="width: 100%" @chaneg-size="changeSizeHandle" @chaneg-page="changePageHandle" @cell-dblclick="copyCellData">
        <el-table-column type="selection" width="55" align="center"></el-table-column>
        <el-table-column prop="id" label="ID" min-width="80" align="center" :show-overflow-tooltip="true"></el-table-column>
        <el-table-column prop="name" label="名称" min-width="150" align="center" :show-overflow-tooltip="true"></el-table-column>
        <el-table-column prop="href" label="链接" min-width="150" align="center" :show-overflow-tooltip="true"></el-table-column>
        <el-table-column prop="hide" label="隐藏" min-width="150" align="center" :show-overflow-tooltip="true">
          <template slot-scope="scope">
            {{scope.row.hide == 1 ? '是':'否'}}
          </template>
        </el-table-column>
        <el-table-column prop="remark" label="备注" min-width="150" align="center" :show-overflow-tooltip="true"></el-table-column>
        <el-table-column prop="seq" label=排序 min-width="150" align="center" :show-overflow-tooltip="true"></el-table-column>
        <el-table-column prop="createAt" label="创建时间" min-width="150" align="center" :show-overflow-tooltip="true"></el-table-column>
        <el-table-column label="操作" min-width="150" :show-overflow-tooltip="true" v-if="rule">
          <template slot-scope="scope">
            <el-button type="primary" size="small" icon="el-icon-edit-outline"  @click="editform = scope.row;editDialogStatus = true;" >编辑
            </el-button>
            <el-button type="danger" size="small" icon="el-icon-delete"  @click="doDelete(scope.row)" >删除
            </el-button>
          </template>
        </el-table-column>
      </baseTable>
    </div>
    <!--表格数据-->

    <!--新增区-->
    <el-dialog :title="'新增'+homeName" :visible.sync="addDialogStatus" width="700px">
      <el-form :model="addform" ref="addform" :inline="true" label-width="80px">
        <el-form-item prop="id" label="ID" >
          <el-input v-model="addform.id" style="width: 220px!important" disabled></el-input>
        </el-form-item>
        <el-form-item prop="parentId" label="父节点" >
          <el-select v-model="addform.parentId" placeholder="请选择" style="width: 220px!important">
            <template v-for="menu in menus">
              <el-option :key="menu.id" :label="menu.name" :value="menu.id"></el-option>
            </template>
          </el-select>
        </el-form-item>
        <el-form-item prop="name" label="名称" >
          <el-input v-model="addform.name" style="width: 220px!important"></el-input>
        </el-form-item>
        <el-form-item prop="href" label="链接" >
          <el-input v-model="addform.href" style="width: 220px!important"></el-input>
        </el-form-item>
        <el-form-item prop="hide" label="隐藏" >
          <el-select v-model="addform.hide" placeholder="请选择" style="width: 220px!important">
            <el-option key="0" label="否" value="0"></el-option>
            <el-option key="1" label="是" value="1"></el-option>
          </el-select>
        </el-form-item>
        <el-form-item prop="remark" label="备注" >
          <el-input v-model="addform.remark" style="width: 220px!important"></el-input>
        </el-form-item>
        <el-form-item prop="seq" label="排序" >
          <el-input v-model="addform.seq" style="width: 220px!important"></el-input>
        </el-form-item>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button @click="addDialogStatus = false">取 消</el-button>
        <el-button type="primary" @click="doCreate()">确 定</el-button>
      </div>
    </el-dialog>
    <!--新增区-->

    <!--编辑区-->
    <el-dialog :title="'编辑'+homeName" :visible.sync="editDialogStatus" width="700px">
      <el-form :model="editform" ref="editform" :inline="true" label-width="80px">
        <el-form-item prop="id" label="ID" >
          <el-input v-model="editform.id" style="width: 220px!important" disabled></el-input>
        </el-form-item>
        <el-form-item prop="parentId" label="父节点" >
          <el-select v-model="editform.parentId" placeholder="请选择" style="width: 220px!important">
            <template v-for="menu in menus">
              <el-option :key="menu.id" :label="menu.name" :value="menu.id"></el-option>
            </template>
          </el-select>
        </el-form-item>
        <el-form-item prop="name" label="名称" >
          <el-input v-model="editform.name" style="width: 220px!important"></el-input>
        </el-form-item>
        <el-form-item prop="href" label="链接" >
          <el-input v-model="editform.href" style="width: 220px!important"></el-input>
        </el-form-item>
        <el-form-item prop="hide" label="隐藏" >
          <el-select v-model="editform.hide" placeholder="请选择" style="width: 220px!important">
            <el-option key="0" label="否" value="0"></el-option>
            <el-option key="1" label="是" value="1"></el-option>
          </el-select>
        </el-form-item>
        <el-form-item prop="remark" label="备注" >
          <el-input v-model="editform.remark" style="width: 220px!important"></el-input>
        </el-form-item>
        <el-form-item prop="seq" label="排序" >
          <el-input v-model="editform.seq" style="width: 220px!important"></el-input>
        </el-form-item>
        <el-form-item label="创建时间" >
          <el-date-picker v-model="editform.createAt" type="datetime" placeholder="选择创建时间"></el-date-picker>
        </el-form-item>
        <el-form-item label="创建者" >
          <el-input v-model="editform.createBy" style="width: 220px!important"></el-input>
        </el-form-item>
        <el-form-item label="更新时间" >
          <el-date-picker v-model="editform.updateAt" type="datetime" placeholder="选择更新时间"></el-date-picker>
        </el-form-item>
        <el-form-item label="更新者" >
          <el-input v-model="editform.updateBy" style="width: 220px!important"></el-input>
        </el-form-item>
      </el-form>
      <div slot="footer" class="dialog-footer" align="center">
        <el-button @click="editDialogStatus = false">取 消</el-button>
        <el-button type="primary" @click="doUpdate()">确 定</el-button>
      </div>
    </el-dialog>
    <!--编辑区-->

    <!--搜索区-->
    <el-dialog :title="'搜索'+homeName" :visible.sync="searchDialogStatus" width="505px">
      <el-form :inline="true" :model="searchform" ref="searchform">
        <el-form-item label="ID">
          <el-input v-model="searchform.id"></el-input>
        </el-form-item>
        <el-form-item label="标题">
          <el-input v-model="searchform.name"></el-input>
        </el-form-item>
      </el-form>
      <div slot="footer" class="dialog-footer" align="center">
        <el-button @click="searchDialogStatus = false">取 消</el-button>
        <el-button type="primary" @click="doSearch();searchDialogStatus = false">确 定</el-button>
      </div>
    </el-dialog>
    <!--搜索区-->
  </div>
</template>

<script>
  import { Web } from "../../static/js/web.js";
  import BaseTable from '@/components/BaseTable';

  export default {
    data() {
      return {
        token:Web.getToken(),
        home:"SystemMenu",
        homeName:'系统菜单',
        rule:Web.getValue("rule") == '1',
        addDialogStatus: false,
        editDialogStatus:false,
        searchDialogStatus: false,
        //查询表单
        searchform: {
          id: '',
          name: '',
          page:1,
          pageSize:10
        },
        //新增表单
        addform: {
          id:"",
          parentId:"",
          name:"",
          href:"",
          hide:"0",
          remark:"",
          seq:"",
        },
        //修改表单
        editform:{
          id:"",
          parentId:"",
          name:"",
          href:"",
          hide:"",
          remark:"",
          seq:"",
          createAt:"",
          createBy:"",
          updateAt:"",
          updateBy:"",
          deleteAt:"",
        },
        menus:Web.getValue("menus")
      }
    },
    components: {
      'baseTable': BaseTable
    },
    mounted: function () {
      let that = this;
      window.vue = that;
      that.rule = true;
      that.init();
    },
    methods: {
      init(){
        let that = this;
        that.doSearch();
      },
      //新增数据
      doCreate(){
        let that = this;
        var data = {
          token:that.token,
          obj:that.addform
        };
        that.axios.post(Web.host + "/api/"+ that.home + "/create.do", data)
          .then(function (res) {
            if(res.data.status){
              that.doSearch();
              that.$nextTick(function () {
                that.$message({
                  showClose: true,
                  message: '创建成功',
                  type: 'success'
                });
                that.addDialogStatus = false;
              })
            }else{
              that.$message({
                showClose: true,
                message: '更新失败,请联系管理员',
                type: 'error'
              });
            }
          })
      },
      //删除数据
      doDelete(row){
        let that = this;
        let table = that.$refs["table"];
        if(row){
          table.chooseArray = [row];
        }
        if(table.chooseArray.length > 0){
          that.$confirm('确定删除这'+ table.chooseArray.length +'条数据?', '提示', {
            confirmButtonText: '确定',
            cancelButtonText: '取消',
            center: true,
            type: 'warning'
          }).then(() => {
            var id = "";
            for(let i = 0;i<table.chooseArray.length;i++){
              if(i > 0){
                id+=","
              }
              id+=table.chooseArray[i].id
            }
            var data = {
              token:that.token,
              id:id
            };
            that.axios.post(Web.host + "/api/"+ that.home + "/delete.do", data)
              .then(function (res) {
                if(res.data.status){
                  that.$message({
                    type: 'success',
                    message: '删除成功'
                  });
                  table.chooseArray = [];
                  that.searchform.page = 1;
                  that.doSearch();
                }else{
                  that.$message({
                    showClose: true,
                    message: '删除失败,请联系管理员',
                    type: 'error'
                  });
                }
              })
          }).catch(() => {})
        }else{
          that.$message({
            showClose: true,
            message: '请选择删除项',
            type: 'error'
          });
        }
      },
      //修改数据
      doUpdate(){
        let that = this;
        var data = {
          token:that.token,
          obj:that.editform
        };
        that.axios.post(Web.host + "/api/"+ that.home + "/update.do", data)
          .then(function (res) {
            if(res.data.status){
              that.$message({
                showClose: true,
                message: '修改成功',
                type: 'success'
              });
              that.doSearch();
              that.$nextTick(function () {
                that.editDialogStatus = false;
              })
            }else{
              that.$message({
                showClose: true,
                message: '更新失败,请联系管理员',
                type: 'error'
              });
            }
          })
      },
      //查询数据
      doSearch() {
        let that = this;
        let table = that.$refs["table"];
        table.wait();
        that.axios.post(Web.host + "/api/"+ that.home + "/search.do", that.searchform)
          .then(function (res) {
            if(res.data.status){
              table.complete().filData(res.data.data);
            }else{
              that.$message({
                showClose: true,
                message: '查询失败,请联系管理员',
                type: 'error'
              });
            }
          })
      },
      //双击表格复制文本
      copyCellData(row, column, cell, event){
        let that = this;
        let text = $(cell).children(".cell").html();
        if(window.clipboardData){
          window.clipboardData.setData('text',text);
        }else{
          (function(s){
            document.oncopy=function(e){
              e.clipboardData.setData('text',text);
              e.preventDefault();
              document.oncopy=null;
            }
          })(text);
          document.execCommand('Copy');
        }
        that.$message({
          showClose: true,
          message: '复制成功',
          type: 'success'
        });
      },
      //重置表单
      resetForm(formName) {
        let that = this;
        that.$nextTick(function () {
          that.$refs[formName].resetFields();
        })
      },
      //改变条数
      changeSizeHandle(size){
        let that = this;
        that.searchform.pageSize = size;
        that.doSearch();
      },
      //跳转页数
      changePageHandle(page){
        let that = this;
        that.searchform.page = page;
        that.doSearch();
      }
    }
  }
</script>
<style>
  .container {
    padding: 10px 20px;
  }
</style>
