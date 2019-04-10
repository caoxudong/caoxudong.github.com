metaspace.hpp

// Metaspace
//
// Metaspaces are Arenas for the VM's metadata.
// They are allocated one per class loader object, and one for the null
// bootstrap class loader
// Eventually for bootstrap loader we'll have a read-only section and read-write
// to write for DumpSharedSpaces and read for UseSharedSpaces
//
//    block X ---+       +-------------------+
//               |       |  Virtualspace     |
//               |       |                   |
//               |       |                   |
//               |       |-------------------|
//               |       || Chunk            |
//               |       ||                  |
//               |       ||----------        |
//               +------>||| block 0 |       |
//                       ||----------        |
//                       ||| block 1 |       |
//                       ||----------        |
//                       ||                  |
//                       |-------------------|
//                       |                   |
//                       |                   |
//                       +-------------------+
//


// Metaspaces each have a  SpaceManager and allocations
// are done by the SpaceManager.  Allocations are done
// out of the current Metachunk.  When the current Metachunk
// is exhausted, the SpaceManager gets a new one from
// the current VirtualSpace.  When the VirtualSpace is exhausted
// the SpaceManager gets a new one.  The SpaceManager
// also manages freelists of available Chunks.
//
// Currently the space manager maintains the list of
// virtual spaces and the list of chunks in use.  Its
// allocate() method returns a block for use as a
// quantum of metadata.













# Resources

* [JEP 122: Remove the Permanent Generation][1]




[1]:    http://openjdk.java.net/jeps/122