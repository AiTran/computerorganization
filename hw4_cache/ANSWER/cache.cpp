#include<iostream>
#include<cstdlib>
#include<fstream>
#include<map>
#include<math.h>
#include<string.h>
#define width 32
#define FIFO 0
#define LRU  1
#define usr  2
#define direct_map 0
#define four_way   1
#define full       2
#define HIT -1
using namespace std;
map<char,int> dict;
ifstream file_in;
ofstream file_out;
unsigned int HexToDec(char HEX[]){
    unsigned int dec=0,base=1;
    int i;
    for(i=7;i>=0;i=i-1,base*=16){
        dec = dec + base* dict[HEX[i]];
    }
    return dec;
}
void DecToBin(unsigned int dec,int bin[]){
    int i = 0 ;
    for(i=0;i<32;i++,dec/=2) bin[i] = dec%2;
}

class NODE {
    private:
        int tag;
        NODE *next;
        NODE *prev;
    public:
        NODE(int tag){
            this->tag = tag;
            this->next = NULL;
            this->prev = NULL;
        }
        int getTag(){return this->tag;}
        friend class linklist;
};

class linklist{
    private:
        int entry;
        int num;
        NODE *header;
        NODE *tailer;
    public:
        linklist(int entry):num(0),entry(entry),header(NULL),tailer(NULL){};
        linklist():num(0),entry(0),header(NULL),tailer(NULL){};
        void setEntry(int entry){this->entry=entry;}
        void push_front(int tag){
            this->num++;
            NODE *tmp = new NODE(tag);
            if(this->header == NULL)
                this->header = this->tailer = tmp ;
            else{
                this->header->prev = tmp;
                tmp->next = this->header;
                this->header = tmp;
            }
        }
        void push_back(int tag){
            this->num ++;
            NODE *tmp = new NODE(tag);
            if(this->tailer == NULL) {
                this->header = this->tailer = tmp;
            }else {
                this->tailer->next = tmp;
                tmp->prev = this->tailer;
                this->tailer =tmp;
            }
        }
        NODE *FindTag(int tag){
            NODE *tmp = header;
            while(tmp!=NULL){
                if(tmp->tag == tag) return tmp;
                tmp = tmp->next;
            }
            return NULL;
        }
        int RemoveFirst(){
            this->num--;
            int tag =this->header->tag;
            if(this->header->next == NULL){ // 1-way
                delete this->header ; 
                this->header = this->tailer =NULL; 
            }
            else {
                NODE *tmp =this->header; 
                this->header = this->header->next;
                this->header->prev = NULL;
                delete tmp;
            }
            return tag;
        }
        int RemoveLast(){
            this->num--;
            int tag = this->tailer->tag;
            if(this->tailer->prev ==NULL){
                delete this->tailer;
                this->tailer = this->header =NULL;
            }
            else {
                NODE *tmp = this->tailer;
                this->tailer = this->tailer->prev;
                this->tailer->next= NULL;
                delete tmp;
            }
            return tag;
        }
        void RemoveNode(NODE *obj){
            this->num--;
            if(obj == this->header && obj==this->tailer){
                this->header = this->tailer = NULL; 
            }
            else {
                if(obj == this->header){
                    this->header = obj->next;
                    this->header->prev = NULL;
                }else if(obj == this->tailer) {
                    this->tailer = obj->prev;
                    this->tailer->next = NULL;
                }else{
                    obj->prev->next=obj->next;
                    obj->next->prev = obj->prev;
                }
            }
            delete obj;
        }
        int isFull(){
            return this->num == this->entry;
        }
        void RemoveAll(){
            NODE *tmp;
            while(this->header!=NULL){
                tmp = this->header;
                delete tmp;
                this->header = this->header->next;
            }
        }
        ~linklist(){
            RemoveAll();
        }
};


class BINARY{
    public:
        BINARY(char HEX[],int tag,int index,int offset){
            strcpy(this->hex,HEX+2);
            this->dec = HexToDec(this->hex);
            DecToBin(this->dec,this->bin); 
            this->tag = tag;
            this->index = index;
            this->offset = offset;
        }
        int getTag(){
            int ans = 0 ,i,base=1;
            for(i=(this->offset+this->index);i<32;i++,base*=2)
                ans = ans + base * bin[i];
            return ans;
        }
        int getIndex(){
            int ans = 0 ,i,base=1;
            for(i=(this->offset);i<(this->offset+this->index);i++,base*=2)
                ans = ans + base * bin[i];
            return ans;
        }
    private:
        unsigned int dec;
        int tag;
        int index;
        int offset;
        int bin[32];
        char hex[9];
};


class CACHE{
    private:
        int tag;
        int index;
        int offset;
        int n_ways;
        int policy;
        int dec_tag;
        int dec_index;
        int entry;
        linklist **space;
    public:
        CACHE(int CacheSize,int BlockSize,int NWay,int Policy){
            int i ;
            this->n_ways     = (NWay == direct_map) ? 1 : (NWay== four_way)? 4 : ((CacheSize * 1024) / BlockSize);
            this->entry      = CacheSize * 1024/BlockSize/this->n_ways; 
            this->policy     = Policy;
            this->offset     = log2(BlockSize); 
            this->index      = log2(this->entry);
            this->tag        = 32 - this->index - this->offset;
            this->dec_tag    = 0;
            this->dec_index  = 0;
            this->space      = new linklist*[this->entry];
            for(i=0;i<this->entry;i++)this->space[i] = new linklist(this->n_ways);
        }
        void start(char hex[]){
            BINARY bin(hex,this->tag,this->index,this->offset);
            this->dec_tag = bin.getTag();
            this->dec_index = bin.getIndex();
            int res;
            //cout<<"tag :" << this->dec_tag << " index :"<<this->dec_index<< endl;
            if (this->policy == FIFO)   res=FIFO_();
            else if (this->policy == LRU) res=LRU_();
            else res=USR_();
            file_out<<res<<endl;   
        }
        int FIFO_(){
            NODE *tmp = this->space[this->dec_index]->FindTag(this->dec_tag);
            if(tmp == NULL){
                if(this->space[this->dec_index]->isFull()){
                    int vict = this->space[this->dec_index]->RemoveLast();
                    this->space[this->dec_index]->push_front(this->dec_tag);
                    return vict;
                }
                this->space[this->dec_index]->push_front(this->dec_tag);
                return -1;
            }
            return -1;
        }
        int LRU_(){
            NODE *tmp = this->space[this->dec_index]->FindTag(this->dec_tag);
            if(tmp == NULL){
                if(this->space[this->dec_index]->isFull()){
                    int vict = this->space[this->dec_index]->RemoveLast();
                    this->space[this->dec_index]->push_front(this->dec_tag);
                    return vict;
                }
                this->space[this->dec_index]->push_front(this->dec_tag);
                return -1;
            }
            int tag = tmp->getTag();
            this->space[this->dec_index]->RemoveNode(tmp);
            this->space[this->dec_index]->push_front(tag);
            return -1;
        }
        int USR_(){
            return -1;
        }
        void print(){
            cout << "tag  :" << this->tag<<endl << "index :" << this->index <<endl<< "offset: " <<this->offset<<endl;
	    cout << "Entry : " <<this->entry<<endl;
        }
        ~CACHE(){
            int i ;
            for(i=0;i<this->entry;i++)delete this->space[i];
        }
};


int main(int argc,char **argv){
    if(argc !=3 ){
        cout<<"Not correct paramter"<<endl;
        exit(1);
    }
    int i;
    char ch='a';
    file_in.open(argv[1],ios_base::in);
    file_out.open(argv[2],ios_base::out|ios_base::trunc);
    for(i=10;i<=15;i=i+1){dict[ch++] = i ;}
    for(i=0,ch='0';i<=9;i++,ch++)dict[ch]=i;
    int CacheSize,BlockSize,Nway,Policy;
    file_in >> CacheSize >> BlockSize >> Nway >> Policy ;
    CACHE cache(CacheSize,BlockSize,Nway,Policy);
    char hex[12];
    cout<<"Cache Sim Start:"<<endl;
    cache.print();
    while(file_in >>hex){
        cache.start(hex);
    }
    file_in.close();
    file_out.close();
    return 0;
}