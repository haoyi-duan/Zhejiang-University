#include "RecordManager.h"
#include "Interpreter.h"
#include "IndexManager.h"
#include "Catalog.h"
#include <cmath>

RecordManager::~RecordManager()
{

}

/*
    判断某个元组是否满足where要求
    tableinfor：某元组属于的表
    row：某元组
    mask：要判断的元素的编号
    w：where结构
*/
bool RecordManager::isSatisfied(Table &tableinfor, tuper &row, vector<int> mask, vector<where> w)
{
    bool res = true;
    for (int i = 0; i < mask.size(); i++)
    {
        if (w[i].d == NULL)
        { //不存在where条件
            continue;
        }
        else if (row[mask[i]]->flag == -1)
        { //int
            switch (w[i].flag)
            {
            case eq:
                if (!(((Datai *)row[mask[i]])->x == ((Datai *)w[i].d)->x))
                    return false;
                break;
            case leq:
                if (!(((Datai *)row[mask[i]])->x <= ((Datai *)w[i].d)->x))
                    return false;
                break;
            case l:
                if (!(((Datai *)row[mask[i]])->x < ((Datai *)w[i].d)->x))
                    return false;
                break;
            case geq:
                if (!(((Datai *)row[mask[i]])->x >= ((Datai *)w[i].d)->x))
                    return false;
                break;
            case g:
                if (!(((Datai *)row[mask[i]])->x > ((Datai *)w[i].d)->x))
                    return false;
                break;
            case neq:
                if (!(((Datai *)row[mask[i]])->x != ((Datai *)w[i].d)->x))
                    return false;
                break;
            default:;
            }
        }
        else if (row[mask[i]]->flag == 0)
        { //Float
            switch (w[i].flag)
            {
            case eq:
                if (!(abs(((Dataf *)row[mask[i]])->x - ((Dataf *)w[i].d)->x) < MIN_Theta))
                    return false;
                break;
            case leq:
                if (!(((Dataf *)row[mask[i]])->x <= ((Dataf *)w[i].d)->x))
                    return false;
                break;
            case l:
                if (!(((Dataf *)row[mask[i]])->x < ((Dataf *)w[i].d)->x))
                    return false;
                break;
            case geq:
                if (!(((Dataf *)row[mask[i]])->x >= ((Dataf *)w[i].d)->x))
                    return false;
                break;
            case g:
                if (!(((Dataf *)row[mask[i]])->x > ((Dataf *)w[i].d)->x))
                    return false;
                break;
            case neq:
                if (!(((Dataf *)row[mask[i]])->x != ((Dataf *)w[i].d)->x))
                    return false;
                break;
            default:;
            }
        }
        else if (row[mask[i]]->flag > 0)
        { //string
            switch (w[i].flag)
            {
            case eq:
                if (!(((Datac *)row[mask[i]])->x == ((Datac *)w[i].d)->x))
                    return false;
                break;
            case leq:
                if (!(((Datac *)row[mask[i]])->x <= ((Datac *)w[i].d)->x))
                    return false;
                break;
            case l:
                if (!(((Datac *)row[mask[i]])->x < ((Datac *)w[i].d)->x))
                    return false;
                break;
            case geq:
                if (!(((Datac *)row[mask[i]])->x >= ((Datac *)w[i].d)->x))
                    return false;
                break;
            case g:
                if (!(((Datac *)row[mask[i]])->x > ((Datac *)w[i].d)->x))
                    return false;
                break;
            case neq:
                if (!(((Datac *)row[mask[i]])->x != ((Datac *)w[i].d)->x))
                    return false;
                break;
            default:;
            }
        }
        else
        { //just for debug
            cout << "Error in RecordManager in function is satisified!" << endl;
            system("pause");
        }
    }
    return res;
}

/*
    将某张表的特定属性投影，返回投影之后的表
    tableIn是待投影的表
    attrSelect是投影的元素序列
*/
Table RecordManager::Select(Table &tableIn, vector<int> attrSelect)
{
    string stringRow;
    string filename = tableIn.Tname + ".table";
    tuper *temp_tuper;
    int length = tableIn.dataSize() + 1;      //一个元组的信息在文档中的长度
    const int recordNum = BLOCKSIZE / length; //一个block中存储的记录条数
    for (int blockOffset = 0; blockOffset < tableIn.blockNum; blockOffset++)
    { //读取整个文件中的所有内容
        int bufferNum = buf_ptr->GiveMeABlock(filename, blockOffset);
        /*
        if (bufferNum == -1)
        { //该块不再内存中，从内存中读取新的块
            bufferNum = buf_ptr->getEmptyBuffer();
            buf_ptr->readBlock(filename, blockOffset, bufferNum);
        }
        */
        for (int offset = 0; offset < recordNum; offset++)
        {
            int position = offset * length;
            stringRow = buf_ptr->bufferBlock[bufferNum].getvalues(position, position + length);
            if (stringRow.c_str()[0] == EMPTY)
                continue;  //该行是空的
            int c_pos = 1; //当前在数据流中指针的位置，0表示该位是否有效，因此数据从第一位开始
            temp_tuper = new tuper;
            for (int attr_index = 0; attr_index < tableIn.attr.num; attr_index++)
            {
                if (tableIn.attr.flag[attr_index] == -1) //int
                {
                    int value;
                    memcpy(&value, &(stringRow.c_str()[c_pos]), sizeof(int));
                    c_pos += sizeof(int);
                    temp_tuper->addData(new Datai(value));
                }
                else if (tableIn.attr.flag[attr_index] == 0) //float
                {
                    float value;
                    memcpy(&value, &(stringRow.c_str()[c_pos]), sizeof(float));
                    c_pos += sizeof(float);
                    temp_tuper->addData(new Dataf(value));
                }
                else
                {
                    char value[MAXSTRINGLEN];
                    int strLen = tableIn.attr.flag[attr_index] + 1;
                    memcpy(value, &(stringRow.c_str()[c_pos]), strLen);
                    c_pos += strLen;
                    temp_tuper->addData(new Datac(string(value)));
                }
            }
            tableIn.addData(temp_tuper);
        }
    }
    return SelectProject(tableIn, attrSelect);
}

/*
    外部接口 用于select
    tablein即选择操作的表
    attrselect即要在哪些属性进行选择
    mask：要判断的元素的编号
    w：where结构
*/
Table RecordManager::Select(Table &tableIn, vector<int> attrSelect, vector<int> mask, vector<where> &w)
{
    if (mask.size() == 0)
    {
        return Select(tableIn, attrSelect);
    }
    /*
    if(mask.size()==1&&w[0].flag==eq&&((Dataf*)w[0].d)->x==100)
    {
        return SelectProject(tableIn, attrSelect);
    }
    */
    string stringRow;

    string filename = tableIn.Tname + ".table";
    string indexfilename;

    int length = tableIn.dataSize() + 1;      //每行数据的长度
    const int recordNum = BLOCKSIZE / length; //一个块中含有的这个表的记录数量

    for (int blockOffset = 0; blockOffset < tableIn.blockNum; blockOffset++)
    {
        int bufferNum = buf_ptr->GiveMeABlock(filename, blockOffset);
        /*
        if (bufferNum == -1)
        { //这个块不在内存中时，取一个空块
            bufferNum = buf_ptr->getEmptyBuffer();
            buf_ptr->readBlock(filename, blockOffset, bufferNum);
        }
        */
        for (int offset = 0; offset < recordNum; offset++)
        {
            int position = offset * length;
            stringRow = buf_ptr->bufferBlock[bufferNum].getvalues(position, position + length);
            if (stringRow.c_str()[0] == EMPTY)
                continue;  //该行是空的
            int c_pos = 1; //当前在数据流中指针的位置，0表示该位是否有效，因此数据从第一位开始
            tuper *temp_tuper = new tuper;
            for (int attr_index = 0; attr_index < tableIn.attr.num; attr_index++)
            {
                if (tableIn.attr.flag[attr_index] == -1)
                { //是一个整数
                    int value;
                    memcpy(&value, &(stringRow.c_str()[c_pos]), sizeof(int));
                    c_pos += sizeof(int);
                    temp_tuper->addData(new Datai(value));
                }
                else if (tableIn.attr.flag[attr_index] == 0)
                { //float
                    float value;
                    memcpy(&value, &(stringRow.c_str()[c_pos]), sizeof(float));
                    c_pos += sizeof(float);
                    temp_tuper->addData(new Dataf(value));
                }
                else //string
                {
                    char value[MAXSTRINGLEN];
                    int strLen = tableIn.attr.flag[attr_index] + 1;
                    memcpy(value, &(stringRow.c_str()[c_pos]), strLen);
                    c_pos += strLen;
                    temp_tuper->addData(new Datac(string(value)));
                }
            } //生成了一个元组，判断是否满足要求

            if (isSatisfied(tableIn, *temp_tuper, mask, w))
            {
                tableIn.addData(temp_tuper);
            }
            else
            {
                delete temp_tuper;
            }
        }
    }
    return SelectProject(tableIn, attrSelect);
}

/*
    用索引查找元素
    tableIn是要查找的表，row是元组，mask是要查找的属性的序号
    返回 被查找元素的位置
*/
int RecordManager::FindWithIndex(Table &tableIn, tuper &row, int mask)
{
    IndexManager indexMA;
    for (int i = 0; i < tableIn.index.num; i++)
    {
        if (tableIn.index.location[i] == mask) //索引存在
        {
            Data *ptrData;
            ptrData = row.data[mask]; //!
            int pos = indexMA.Find(tableIn.Tname + to_string(mask) + ".index", ptrData);
            return pos;
        }
    }
    //没找到元素或没有索引
    return -1;
}

void RecordManager::InsertWithIndex(Table &tableIn, tuper &singleTuper)
{

    //check Redundancy using index

    for (int i = 0; i < tableIn.attr.num; i++)
    {
        if (tableIn.attr.unique[i] == 1)
        {
            int addr = FindWithIndex(tableIn, singleTuper, i);
            if (addr >= 0)
            { //already in the table
                throw QueryException("Unique Value Redundancy occurs, thus insertion failed");
                return;
            }
        }
    }

    //check redundancy only use normal select
    // for (int i = 0; i < tableIn.attr.num; i++)
    // {
    //     if (tableIn.attr.unique[i])
    //     {
    //         bool checkdone = false;
    //         for (int j = 0; j < tableIn.index.num; j++)
    //         {
    //             if (i == tableIn.index.location[j])
    //                 checkdone = true;
    //         }
    //         if (checkdone)
    //             continue;

    //         vector<where> w;
    //         vector<int> mask;
    //         where *uni_w = new where;
    //         uni_w->flag = eq;
    //         switch (singleTuper[i]->flag)
    //         {
    //         case -1:
    //             uni_w->d = new Datai(((Datai *)singleTuper[i])->x);
    //             break;
    //         case 0:
    //             uni_w->d = new Dataf(((Dataf *)singleTuper[i])->x);
    //             break;
    //         default:
    //             uni_w->d = new Datac(((Datac *)singleTuper[i])->x);
    //             break;
    //         }
    //         w.push_back(*uni_w);
    //         mask.push_back(i);
    //         Table temp_table = Select(tableIn, mask, mask, w);

    //         if (temp_table.T.size() != 0)
    //         {
    //             throw QueryException("Unique Value Redundancy occurs, thus insertion failed");
    //         }

    //         delete uni_w->d;
    //         delete uni_w;
    //     }
    // }

    tableIn.addData(&singleTuper);
    char *charTuper;
    charTuper = Tuper2Char(tableIn, singleTuper); //把一个元组转换成字符串

    insertPos iPos = buf_ptr->getInsertPosition(tableIn); //获取插入位置
    buf_ptr->bufferBlock[iPos.bufferNum].values[iPos.position] = NOTEMPTY;
    memcpy(&(buf_ptr->bufferBlock[iPos.bufferNum].values[iPos.position + 1]), charTuper, tableIn.dataSize());
    int length = tableIn.dataSize() + 1; //一个元组的信息在文档中的长度
    //insert tuper into index file
    IndexManager indexMA;
    int blockCapacity = BLOCKSIZE / length;
    int tuperAddr = buf_ptr->bufferBlock[iPos.bufferNum].blockOffset * blockCapacity + iPos.position / length; //the tuper's addr in the data file
    for (int j = 0; j < tableIn.index.num; j++)
    {
        const string argu = tableIn.index.indexname[j] + ".index";
        indexMA.Insert(argu, singleTuper[tableIn.index.location[j]], tuperAddr);
    }

    buf_ptr->writeBlock(iPos.bufferNum);
    delete[] charTuper;
}

/* 
    将某张表的某个元组转化为char数组
    参数 tableIn 该元组从属的表， singleTuple 该元组
    返回字符串首地址
*/
char *RecordManager::Tuper2Char(Table &tableIn, tuper &singleTuper)
{
    char *result;
    int pos = 0; //pos stores the store location
    result = new char[(tableIn.dataSize() + 1) * sizeof(char)];
    for (int i = 0; i < tableIn.attr.num; i++)
    {
        if (tableIn.attr.flag[i] == -1) //int
        {
            int value = ((Datai *)singleTuper[i])->x;
            memcpy(result + pos, &value, sizeof(int));
            pos += sizeof(int);
        }
        else if (tableIn.attr.flag[i] == 0) //float
        {
            float value = ((Dataf *)singleTuper[i])->x;
            memcpy(result + pos, &value, sizeof(float));
            pos += sizeof(float);
        }
        else //string
        {
            string value(((Datac *)singleTuper[i])->x);
            int strLen = tableIn.attr.flag[i] + 1;
            memcpy(result + pos, value.c_str(), strLen); //多加1，拷贝最后的'\0';
            pos += strLen;
        }
    }
    result[tableIn.dataSize()] = '\0';
    return result;
}

//delete the record and its index
int RecordManager::Delete(Table &tableIn, vector<int> mask, vector<where> w)
{
    IndexManager indexMA;
    string filename = tableIn.Tname + ".table";
    string stringRow;

    int count = 0;
    int length = tableIn.dataSize() + 1;
    const int recordNum = BLOCKSIZE / length;
    for (int blockOffset = 0; blockOffset < tableIn.blockNum; blockOffset++)
    {
        int bufferNum = buf_ptr->GiveMeABlock(filename, blockOffset);
        /*
        if (bufferNum == -1)
        {
            bufferNum = buf_ptr->getEmptyBuffer();
            buf_ptr->readBlock(filename, blockOffset, bufferNum);
        }
        */
        for (int offset = 0; offset < recordNum; offset++)
        {
            int position = offset * length;
            stringRow = buf_ptr->bufferBlock[bufferNum].getvalues(position, position + length);
            if (stringRow.c_str()[0] == EMPTY)
                continue;  //该行是空的
            int c_pos = 1; //当前在数据流中指针的位置，0表示该位是否有效，因此数据从第一位开始
            tuper *temp_tuper = new tuper;
            for (int attr_index = 0; attr_index < tableIn.attr.num; attr_index++)
            {
                if (tableIn.attr.flag[attr_index] == -1)
                { //是一个整数
                    int value;
                    memcpy(&value, &(stringRow.c_str()[c_pos]), sizeof(int));
                    c_pos += sizeof(int);
                    temp_tuper->addData(new Datai(value));
                }
                else if (tableIn.attr.flag[attr_index] == 0)
                { //float
                    float value;
                    memcpy(&value, &(stringRow.c_str()[c_pos]), sizeof(float));
                    c_pos += sizeof(float);
                    temp_tuper->addData(new Dataf(value));
                }
                else
                {
                    char value[MAXSTRINGLEN];
                    int strLen = tableIn.attr.flag[attr_index] + 1;
                    memcpy(value, &(stringRow.c_str()[c_pos]), strLen);
                    c_pos += strLen;
                    temp_tuper->addData(new Datac(string(value)));
                }
            } //以上内容先从文件中生成一行tuper，一下判断是否满足要求

            if (isSatisfied(tableIn, *temp_tuper, mask, w))
            {
                buf_ptr->bufferBlock[bufferNum].values[position] = DELETED; //DELETED==EMYTP
                buf_ptr->writeBlock(bufferNum);
                for (int i = 0; i < tableIn.index.num; i++)
                {

                    indexMA.Delete(tableIn.index.indexname[i] + ".index", (*temp_tuper).data[tableIn.index.location[i]]);

                    //indexMA.Delete(tableIn.index.indexname[i]+ ".index",(*temp_tuper)[tableIn.index.location[i]]);
                }
                count++;
            }
        }
    }
    return count;
}

bool RecordManager::DropTable(Table &tableIn)
{
    string filename = tableIn.Tname + ".table";
    if (remove(filename.c_str()) != 0)
    {
        throw TableException("Can't delete the file!\n");
    }
    else
    {
        buf_ptr->setInvalid(filename);
    }
    return true;
}

bool RecordManager::CreateTable(Table &tableIn)
{

    string filename = tableIn.Tname + ".table";
    fstream fout(filename.c_str(), ios::out);
    //buf_ptr->InitializeLList(tableIn);
    fout.close();
    tableIn.blockNum = 1;
    CataManager Ca;
    Ca.changeblock(tableIn.Tname, 1);
    return true;
}
/*
    将某张表的特定属性投影，返回投影之后的表
    tableIn是待投影的表
    attrSelect是投影的属性的序号
*/
Table RecordManager::SelectProject(Table &tableIn, vector<int> attrSelect)
{
    //将原表tableIn的属性信息拷贝到新表中
    Attribute attrResult;
    attrResult.num = attrSelect.size();
    for (int i = 0; i < attrResult.num; i++)
    {
        attrResult.name[i] = tableIn.attr.name[attrSelect[i]];
        attrResult.unique[i] = tableIn.attr.unique[attrSelect[i]];
        attrResult.flag[i] = tableIn.attr.flag[attrSelect[i]];
    }
    Table tableOut(tableIn.Tname, attrResult, tableIn.blockNum);

    //将原表特定属性的数据复制到新表中
    int fitAttr;
    for (int i = 0; i < tableIn.T.size(); i++) //for every tuper
    {
        tuper *ptrTuper = new tuper;
        for (int j = 0; j < attrSelect.size(); j++) //for every data in a tuper
        {
            fitAttr = attrSelect[j];
            Data *resadd = NULL;
            if (tableIn.T[i]->operator[](fitAttr)->flag == -1)
            {
                resadd = new Datai((*((Datai *)tableIn.T[i]->operator[](fitAttr))).x);
            }
            else if (tableIn.T[i]->operator[](fitAttr)->flag == 0)
            {
                resadd = new Dataf((*((Dataf *)tableIn.T[i]->operator[](fitAttr))).x);
            }
            else if (tableIn.T[i]->operator[](fitAttr)->flag > 0)
            {
                resadd = new Datac((*((Datac *)tableIn.T[i]->operator[](fitAttr))).x);
            }
            ptrTuper->addData(resadd);
        }
        tableOut.addData(ptrTuper);
    }
    return tableOut;
}
void RecordManager::CreateIndexCatalog(string iname, int attr, string tname, Table &tableIn)
{
    string stringRow;
    string filename = tableIn.Tname + ".table";
    string newindexname = iname + ".index";
    IndexManager indexMA;
    int length = tableIn.dataSize() + 1;      //每行数据的长度
    const int recordNum = BLOCKSIZE / length; //一个块中含有的这个表的记录数量

    for (int blockOffset = 0; blockOffset < tableIn.blockNum; blockOffset++)
    {
        int bufferNum = buf_ptr->GiveMeABlock(filename, blockOffset);
        for (int offset = 0; offset < recordNum; offset++)
        {
            int position = offset * length;
            stringRow = buf_ptr->bufferBlock[bufferNum].getvalues(position, position + length);
            if (stringRow.c_str()[0] == EMPTY)
                continue;  //该行是空的
            int c_pos = 1; //当前在数据流中指针的位置，0表示该位是否有效，因此数据从第一位开始
            tuper *temp_tuper = new tuper;
            for (int attr_index = 0; attr_index < tableIn.attr.num; attr_index++)
            {
                if (tableIn.attr.flag[attr_index] == -1)
                { //int
                    int value;
                    memcpy(&value, &(stringRow.c_str()[c_pos]), sizeof(int));
                    c_pos += sizeof(int);
                    temp_tuper->addData(new Datai(value));
                }
                else if (tableIn.attr.flag[attr_index] == 0)
                { //float
                    float value;
                    memcpy(&value, &(stringRow.c_str()[c_pos]), sizeof(float));
                    c_pos += sizeof(float);
                    temp_tuper->addData(new Dataf(value));
                }
                else //string
                {
                    char value[MAXSTRINGLEN];
                    int strLen = tableIn.attr.flag[attr_index] + 1;
                    memcpy(value, &(stringRow.c_str()[c_pos]), strLen);
                    c_pos += strLen;
                    temp_tuper->addData(new Datac(string(value)));
                }
            }
            int blockCapacity = BLOCKSIZE / length;
            int tuperAddr = blockOffset * blockCapacity + offset;
            indexMA.Insert(newindexname, (*temp_tuper)[attr], tuperAddr);
            //tableIn.addData(temp_tuper);
            delete temp_tuper;
        }
    }
}

tuper *RecordManager::Char2Tuper(Table &tableIn, char *stringRow)
{
    tuper *temp_tuper;
    temp_tuper = new tuper;
    if (stringRow[0] == EMPTY)
        return temp_tuper; //该行是空的
    int c_pos = 1;         //当前在数据流中指针的位置，0表示该位是否有效，因此数据从第一位开始
    for (int attr_index = 0; attr_index < tableIn.attr.num; attr_index++)
    {
        if (tableIn.attr.flag[attr_index] == -1)
        { //int
            int value;
            memcpy(&value, &(stringRow[c_pos]), sizeof(int));
            c_pos += sizeof(int);
            temp_tuper->addData(new Datai(value));
        }
        else if (tableIn.attr.flag[attr_index] == 0)
        { //float
            float value;
            memcpy(&value, &(stringRow[c_pos]), sizeof(float));
            c_pos += sizeof(float);
            temp_tuper->addData(new Dataf(value));
        }
        else
        { //string
            char value[MAXSTRINGLEN];
            int strLen = tableIn.attr.flag[attr_index] + 1;
            memcpy(value, &(stringRow[c_pos]), strLen);
            c_pos += strLen;
            temp_tuper->addData(new Datac(string(value)));
        }
    } //以上内容先从文件中生成一行tuper
    return temp_tuper;
}

//check if the data is unique, but the search without index is too slow,so i don`t use it
bool RecordManager::UNIQUE(Table &tableIn, where w, int loca)
{
    int length = tableIn.dataSize() + 1;      //一个元组的信息在文档中的长度
    const int recordNum = BLOCKSIZE / length; //一个block中存储的记录条数
    string stringRow;
    string filename = tableIn.Tname + ".table";
    int attroff = 1;
    for (int i = 0; i < loca - 1; i++)
    {
        if (tableIn.attr.flag[i] == -1)
        {
            attroff += sizeof(int);
        }
        else if (tableIn.attr.flag[i] == 0)
        {
            attroff += sizeof(float);
        }
        else
        {
            attroff += sizeof(char) * tableIn.attr.flag[i];
        }
    }
    int inflag = tableIn.attr.flag[loca];
    for (int blockOffset = 0; blockOffset < tableIn.blockNum; blockOffset++)
    {
        int bufferNum = buf_ptr->GiveMeABlock(filename, blockOffset);
        /*
        if (bufferNum == -1)
        { //该块不再内存中，取一个新的块读取
            bufferNum = buf_ptr->;
            buf_ptr->readBlock(filename, blockOffset, bufferNum);
        }
        */
        for (int offset = 0; offset < recordNum; offset++)
        {
            int position = offset * length + attroff;
            if (inflag == -1)
            {
                int value;
                memcpy(&value, &(bf.bufferBlock[bufferNum].values[position + 4]), sizeof(int));
                if (value == ((Datai *)(w.d))->x)
                    return false;
            }
            else if (inflag == 0)
            {
                float value;
                memcpy(&value, &(bf.bufferBlock[bufferNum].values[position + 4]), sizeof(float));
                if (value == ((Dataf *)(w.d))->x)
                    return false;
            }
            else
            {
                char value[100];
                memcpy(value, &(bf.bufferBlock[bufferNum].values[position + 4]), tableIn.attr.flag[loca] + 1);
                value[tableIn.attr.flag[loca]] = '\0';
                if (string(value) == ((Datac *)(w.d))->x)
                    return false;
            }
        }
    }
    return true;
}
