using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

using System.Threading;

class TcpLcQueue
{
    /// <summary>
    /// 队列类（使用循环数组）(加上线程安全)
    /// </summary>
    /// <typeparam name="T">队列中元素的类型</typeparam>
    public class Queue<T>
    {
        /// <summary>
        /// 通知的状态机
        /// </summary>
        AutoResetEvent notice = new AutoResetEvent(true);
        private const int MAX_QUEUE_LEN = 512;
        /// <summary>
        /// 循环数组，初始大小为256
        /// </summary>
        T[] ary = new T[MAX_QUEUE_LEN];
        /// <summary>
        /// 队头
        /// </summary>
        int front = 0;
        /// <summary>
        /// 队尾
        /// </summary>
        int rear = 0;
        /// <summary>
        /// 队大小
        /// </summary>
        int size = 0;
        /// <summary>
        /// 入队
        /// </summary>
        /// <param name="t">入队元素</param>
        public void Enqueue(T t)
        {
            Lock();
            //如果队列大小等于数组长度，那么数组大小加倍
            if (size == ary.Length)
            {
                //DoubleSize();
                UnLock();
                throw new Exception("队列已经满了");
            }
            ary[rear] = t;
            //队尾前移
            rear++;
            //这一句是循环数组的关键：
            //如果rear超过数组下标了，
            //那么将从头开始使用数组。
            rear %= ary.Length;
            //大小加一
            size++;
            UnLock();
        }
        /// <summary>
        /// 出队
        /// </summary>
        /// <returns>出队元素</returns>
        public T Dequeue()
        {
            Lock();
            //如果大小为零，那么队列已经空了
            if (size == 0)
            {
                UnLock();
                throw new Exception("队列已经空了");
            }
            T t = ary[front];
            //队头前移
            front++;
            //这一句是循环数组的关键：
            //如果front超过数组下标了，
            //那么将从头开始使用数组。
            front %= ary.Length;
            //大小减一
            size--;
            UnLock();
            return t;
        }
        /// <summary>
        /// 从队头提取一个元素（不删除）
        /// </summary>
        /// <returns></returns>
        public T Peek()
        {
            Lock();
            //如果大小为零，那么队列已经空了
            if (size == 0)
            {
                UnLock();
                throw new Exception("队列已经空了");
            }
            T t = ary[front];
            UnLock();
            return t;
        }
        /// <summary>
        /// 队大小
        /// </summary>
        public int Count
        {
            get
            {
                Lock();
                int result = size;
                UnLock();
                return result;
            }
        }

        public bool isFull()
        {
            if (size == MAX_QUEUE_LEN)
            {
                return true;
            }

            return false;
        }

        public bool isEmpty()
        {
            if (size == 0)
            {
                return true;
            }

            return false;
        }
        /// <summary>
        /// 清除队中的元素
        /// </summary>
        public void Clear()
        {
            Lock();
            size = 0;
            front = 0;
            rear = 0;
            ary = new T[ary.Length];
            UnLock();
        }
        /// <summary>
        /// 数组大小加倍
        /// </summary>
        private void DoubleSize()
        {
            //临时数组
            T[] temp = new T[ary.Length];
            //将原始数组的内容拷贝到临时数组
            Array.Copy(ary, temp, ary.Length);
            //原始数组大小加倍
            ary = new T[ary.Length * 2];
            //将临时数组的内容拷贝到新数组中
            for (int i = 0; i < size; i++)
            {
                ary[i] = temp[front];
                front++;
                front %= temp.Length;
            }
            front = 0;
            rear = size;
        }
        /// <summary>
        /// 锁定
        /// </summary>
        private void Lock()
        {
            notice.WaitOne();
        }
        /// <summary>
        /// 解锁
        /// </summary>
        private void UnLock()
        {
            notice.Set();
        }
    }
}

